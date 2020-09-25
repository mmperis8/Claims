tableextension 50321 "Purchase Line Claim" extends "Purchase Line"
{
    fields
    {
        field(50320; "Claim No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Claim No.', comment = 'ESP="Nº Reclamación",PTG="Nº Reivindicação"';
            TableRelation = Claims."No.";
        }
    }
}