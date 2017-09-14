function out = anisog(sigmax, sigmay)

    k = 2*(sigmax+sigmay)+mod(sigmax+sigmay,2);%The filter support
    x = [-k:k];%for a [kxk] filter
    y = x';
    c = 1/(2*pi*sigmax*sigmay);%The normalization constant
    out = c* exp(-0.5*(((x.^2)/sigmax^2)+((y.^2)/sigmay^2)));
    %equation from http://mathinfo.univ-reims.fr/IMG/pdf/Fast_Anisotropic_Gquss_Filtering_-_GeusebroekECCV02.pdf
    
end