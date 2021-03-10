function [ fmeasure ] = CalFMeasure( tp, fp, fn, beta)

    if (tp + fp + fn == 0)
        fmeasure = 1;
    else
        beta2 = beta * beta;
        fmeasure = ((beta2 + 1)*tp)/((beta2 + 1)*tp + beta2*fn + fp);
    end

end

