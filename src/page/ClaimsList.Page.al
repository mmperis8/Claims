page 50327 "Claims List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Claims;
    Caption = 'Claims List', comment = 'ESP="Lista de reclamaciones",PTG="Lista de reclamações"';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field("Customer No."; "Customer No.")
                {
                    ApplicationArea = All;
                    NotBlank = true;
                }
                field("Wheel Item No."; "Wheel Item No.")
                {
                    ApplicationArea = All;
                    NotBlank = true;
                }
                field("Plaque Code"; "Plaque Code")
                {
                    ApplicationArea = All;
                    NotBlank = true;
                }
                field("Reclamation date"; "Reclamation date")
                {
                    ApplicationArea = All;
                    NotBlank = true;
                }
                field("M.E"; "M.E")
                {
                    ApplicationArea = All;
                    NotBlank = true;
                }
                field("Vehicle Kms."; "Vehicle Kms.")
                {
                    ApplicationArea = All;
                }
                field("Mm. Start"; "Mm. Start")
                {
                    ApplicationArea = All;
                }
                field("Mm. Substract"; "Mm. Substract")
                {
                    ApplicationArea = All;
                    NotBlank = true;
                }
                field("Source No."; "Source No.")
                {
                    ApplicationArea = All;
                }
                field("Source Line No."; "Source Line No.")
                {
                    ApplicationArea = All;
                }
                field("Vendor Observations"; "Vendor Observations")
                {
                    ApplicationArea = All;
                }
                field("Customer Liquidation"; "Customer Liquidation")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Vendor Liquidation"; "Vendor Liquidation")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }
}