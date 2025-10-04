function [ts_out, rmse_out, method] = choose_settling(t, y, Period, pct, Kss, tail_sec)
% Choose settling time based on:
% 1) periodic amplitude stabilization; else
% 2) MATLAB-style relative settling on the main signal.
%
% pct: relative tolerance (e.g., 0.02 for 2%)
% tail_sec: seconds used to estimate final value and compute RMSE

    % ---- 1) Attempt periodic criterion (unchanged logic, slight polish) ----
    [ts_per, A_ss] = settling_time_periodic(t, y, Period, pct, Kss);
    if isfinite(ts_per) && ~isnan(ts_per)
        ts_out   = ts_per;
        rmse_out = rmse_over_tail(t, y, ts_out, tail_sec, Period); % SS RMSE (periodic detrend)
        method   = "periodic";
        return;
    end

    % ---- 2) Fallback: MATLAB-like relative settling on the MAIN SIGNAL ----
    % Estimate final value from the tail, then use error and relative band wrt step amplitude
    y_final = estimate_final_value(t, y, tail_sec);
    e = y - y_final;                                  % error vs final value
    A = abs(y_final - y(1));                          % step amplitude (MATLAB convention)
    if ~isfinite(A) || A == 0
        A = max(abs(e), [], 'omitnan');               % fallback if no step (e.g., tiny amplitude)
    end
    band = pct * max(A, realmin);                     % relative band

    ts_abs = settling_time_rel_err_simple(t, abs(e), band);  % first time after last violation
    ts_out = ts_abs;                                   % may be NaN if never settles
    rmse_out = rmse_over_tail_error(t, e, ts_out, tail_sec); % RMSE of error over tail
    method   = "relative_on_signal";
end

% ---------- Minimal: relative settling using |e| and an ABS band value ----------
function ts = settling_time_rel_err_simple(t, e_abs, band_abs)
    % First time after which |e| <= band_abs for the remainder (sample-level).
    in_band  = isfinite(e_abs) & (e_abs <= band_abs);
    last_bad = find(~in_band, 1, 'last');
    if isempty(last_bad)
        ts = t(1);
    elseif last_bad < numel(t) && all(in_band(last_bad+1:end))
        ts = t(last_bad+1);
    else
        ts = NaN;
    end
end

% ---------- RMSE of ERROR over the tail window ----------
function r = rmse_over_tail_error(t, e, ts, tail_sec)
    t_end = t(end);
    if isnan(ts)
        t_start = max(t_end - tail_sec, t(1));
    else
        t_start = ts;
    end
    idx = (t >= t_start);
    ewin = e(idx);
    r = sqrt(mean(ewin.^2, 'omitnan'));
end

% ---------- Your periodic method (kept, with 0.8 in-band relaxation) ----------
function [ts, A_ss] = settling_time_periodic(t, y, T, eps_rel, K_ss)
    if isempty(T), T = estimate_period_acf(t,y); end
    if ~isscalar(T) || ~isfinite(T) || T<=0, ts = NaN; A_ss = NaN; return; end

    t0 = t(1); t_end = t(end);
    t_edges = (t0:T:t_end).';
    if numel(t_edges) < K_ss+2, ts = NaN; A_ss = NaN; return; end

    A = nan(numel(t_edges)-1,1);
    for k = 1:numel(A)
        idx = t >= t_edges(k) & t < t_edges(k+1);
        if nnz(idx) >= 3
            yw = y(idx);
            A(k) = max(yw) - min(yw);
        end
    end
    valid = isfinite(A);
    A = A(valid);
    t_mid = (t_edges(1:end-1) + t_edges(2:end))/2;
    t_mid = t_mid(valid);

    if numel(A) < K_ss, ts = NaN; A_ss = NaN; return; end

    A_ss = median(A(end-K_ss+1:end));
    lo = (1-eps_rel)*A_ss; hi = (1+eps_rel)*A_ss;
    M = max(5, ceil(K_ss/2));
    ts = NaN;
    p_in = 0.85;  % allow up to 20% out-of-band inside the window
    for i = 1:numel(A)-M+1
        block = A(i:i+M-1);
        inband = (block >= lo) & (block <= hi);
        if mean(inband) >= p_in
            ts = t_mid(i);
            break;
        end
    end
end

% ---------- Final value estimate from tail ----------
function y_final = estimate_final_value(t, y, tail_sec)
    % Use median over the last 'tail_sec' seconds (robust to outliers).
    if tail_sec <= 0 || numel(t) < 2
        y_final = y(end);
        return;
    end
    t_end = t(end);
    idx = t >= max(t_end - tail_sec, t(1));
    y_tail = y(idx);
    if isempty(y_tail)
        y_final = y(end);
    else
        y_final = median(y_tail, 'omitnan');
    end
end

% ---------- Period estimation helper (unchanged) ----------
function T = estimate_period_acf(t, y)
    t = t(:); y = y(:);
    dt = median(diff(t));
    if ~isfinite(dt) || dt <= 0 || numel(t) < 8
        T = NaN; return;
    end
    tu = (t(1):dt:t(end)).';
    yu = interp1(t, y, tu, 'pchip', 'extrap');
    yu = detrend(yu);

    acf = xcorr(yu, 'coeff');
    lags = (-numel(yu)+1:numel(yu)-1).' * dt;

    pos = lags > 0;
    lags = lags(pos); acf = acf(pos);
    if numel(acf) < 5, T = NaN; return; end

    d1 = diff(acf);
    locs = find(d1(1:end-1) > 0 & d1(2:end) <= 0) + 1;
    if isempty(locs), T = NaN; return; end

    good = lags(locs) > 3*dt;
    if any(good), T = lags(locs(find(good,1,'first')));
    else,         T = lags(locs(1));
    end
    if ~isfinite(T) || T <= 0, T = NaN; end
end

function r = rmse_over_tail(t, y, ts, tail_sec, Period)
    % RMSE on the tail of y.
    % If ts is valid, use [ts, end]; else use the last tail_sec.
    % If Period is provided/positive, remove a moving average over ~one period.

    t_end = t(end);
    if isnan(ts)
        t_start = max(t_end - tail_sec, t(1));
    else
        t_start = ts;
    end
    idx  = (t >= t_start);
    ywin = y(idx);

    if ~isempty(Period) && isfinite(Period) && Period > 0 && nnz(idx) > 1
        dt = mean(diff(t(idx)));
        if isfinite(dt) && dt > 0
            k = max(1, round(Period/dt));
            ymean = movmean(ywin, k, 'Endpoints','shrink');
            ywin  = ywin - ymean;
        end
    end

    r = sqrt(mean(ywin.^2, 'omitnan'));
end

