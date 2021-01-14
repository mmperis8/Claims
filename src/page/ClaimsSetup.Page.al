page 50335 "Claims Setup"
{
    ApplicationArea = All;
    Caption = 'Claims Setup', comment = 'ESP="Configuración Reclamaciones"';
    PageType = Card;
    SourceTable = "Claims Setup";
    UsageCategory = Administration;
    layout
    {
        area(content)
        {
            group(General)
            {
                field("Claim Nos."; Rec."Claim Nos.")
                {
                    ApplicationArea = All;
                }
                field("Default Return Reason"; "Default Return Reason")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Reset();
        if not Get() then begin
            Init();
            Insert();
        end;
    end;
}