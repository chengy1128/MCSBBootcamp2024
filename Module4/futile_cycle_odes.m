function dXdt = futile_cycle_odes(t, X, params)
    % Unpack parameters
    kAon = params.kAon;
    kAoff = params.kAoff;
    kIon = params.kIon;
    kIoff = params.kIoff;
    kIcat = params.kIcat;
    kAcat = params.kAcat;
    Ptot = params.Ptot;
    Ktot = params.Ktot;

    % Unpack variables
    A = X(1);
    I = X(2);
    AP = X(3);
    IK = X(4);

    % ODEs
    dA_dt = -kAon * (Ptot - AP) * A + kAoff * AP + kAcat * IK;
    dI_dt = -kIon * (Ktot - IK) * I + kIoff * IK + kIcat * AP;
    dAP_dt = kAon * (Ptot - AP) * A - kAoff * AP - kIcat * AP;
    dIK_dt = kIon * (Ktot - IK) * I - kIoff * IK - kAcat * IK;

    % Return derivatives
    dXdt = [dA_dt; dI_dt; dAP_dt; dIK_dt];
end
