function [H] = myTriangleMask(M, N, K)
    H = zeros(M, N);
    for i = 1 : K
        if i > M
            continue;
        end
        for j = 1 : K - i + 1
            if j > M
                continue;
            end
            H(i, j) = 1;
        end
    end
end

