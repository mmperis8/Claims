tableextension 50320 "G/L Account Claim" extends "G/L Account"
{
    fields
    {
        field(50320; "Claiming Account"; Boolean)
        {
            Caption = 'Claiming Account', Comment = 'ESP="Cuenta de reclamaciones",PTG="Conta de reclamações"';
            DataClassification = CustomerContent;
        }

    }
}