pageextension 50322 "Purchase Order Sub Claim" extends "Purch. Cr. Memo Subform"
{
    layout
    {
        addlast(Control1)
        {
            field("Claim No."; "Claim No.")
            {
                ApplicationArea = All;
            }
        }
    }
}