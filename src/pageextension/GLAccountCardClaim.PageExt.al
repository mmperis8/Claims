pageextension 50320 "G/L Account Card Claim" extends "G/L Account Card"
{
    layout
    {
        addlast(Posting)
        {
            field("Claiming Account"; Rec."Claiming Account")
            {
                ApplicationArea = All;
            }
        }
    }
}