report 50320 "Claim Sheet"
{
    Caption = 'Claim Sheet', Comment = 'ESP="Hoja reclamación",PTG="Folha reclamação"';
    UsageCategory = None;
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/ClaimSheet.Report.rdl';

    dataset
    {
        dataitem(Claims; Claims)
        {
            RequestFilterFields = "No.";
            DataItemTableView = sorting("No.");
            column(ReportTitle; ReportTitle)
            {
            }
            column(No_; "No.")
            {
                IncludeCaption = true;
            }
            column(Location_Code; "Location Code")
            {
                IncludeCaption = true;
            }
            column(Customer_No_; "Customer No.")
            {
                IncludeCaption = true;
            }
            column(Customer_Name; Customer.Name)
            {
            }
            column(Vehicle_Type; "Vehicle Type")
            {
                IncludeCaption = true;
            }
            column(Wheel_Item_No_; "Wheel Item No.")
            {
                IncludeCaption = true;
            }
            column(Item_Description; Item.Description)
            {
            }
            column(Tire_Id_; "Tire Id.")
            {
                IncludeCaption = true;
            }
            column(Vehicle_Kms_; "Vehicle Kms.")
            {
                IncludeCaption = true;
                DecimalPlaces = 0 : 0;
            }
            column(Mm__Start; "Mm. Start")
            {
                IncludeCaption = true;
            }
            column(Mm__Substract; "Mm. Substract")
            {
                IncludeCaption = true;
            }
            column(M_E; "M.E")
            {
                IncludeCaption = true;
            }
            column(Vendor_Observations; "Vendor Observations")
            {
                IncludeCaption = true;
            }
            column(Coordinator_Review_Date; "Coordinator Review Date")
            {
            }
            column(Manufacturer_Review_Date; "Manufacturer Review Date")
            {
            }
            column(Vendor_Cr_Memo_Amount; "Vendor Cr Memo Amount")
            {
            }
            column(Vendor_Cr_Memo_No_; "Vendor Cr Memo No.")
            {
                IncludeCaption = true;
            }
            column(EmptySheet; EmptySheet)
            {
            }
            column(UserTitle; UserTitle)
            {
            }
            column(DistributorTitle; DistributorTitle)
            {
            }
            column(SignatureTitle; SignatureTitle)
            {
            }
            column(ReviewTitle; ReviewTitle)
            {
            }
            column(DateTitle; DateTitle)
            {
            }
            column(CoordinatorTitle; CoordinatorTitle)
            {
            }
            column(ManufacturerTitle; ManufacturerTitle)
            {
            }
            column(BonificationTitle; BonificationTitle)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if not Customer.Get("Customer No.") then
                    Customer.Init();
                if not Item.Get("Wheel Item No.") then
                    Item.Init();
            end;
        }
    }
    var
        Customer: Record Customer;
        Item: Record Item;
        EmptySheet: Boolean;
        UserTitle: Label 'User', Comment = 'ESP="Usuario",PTG="Usuário"';
        DistributorTitle: Label 'Distributor', Comment = 'ESP="Distribuidor",PTG="Distribuidor"';
        SignatureTitle: Label 'Signature', Comment = 'ESP="Firma",PTG="Assinatura"';
        ReviewTitle: Label 'Review', Comment = 'ESP="Revisión",PTG="Revisão"';
        DateTitle: Label 'Date', Comment = 'ESP="Fecha",PTG="Data"';
        CoordinatorTitle: Label 'Coordinator', Comment = 'ESP="Coordinador",PTG="Coordenador"';
        ManufacturerTitle: Label 'Manufacturer', Comment = 'ESP="Fabricante",PTG="Criador"';
        BonificationTitle: Label 'Bonification', Comment = 'ESP="Bonificación",PTG="Bônus"';
        ReportTitle: Label 'PRODUCT EXAMINATION REQUEST', Comment = 'ESP="SOLICITUD DE EXAMEN PRODUCTO",PTG="SOLICITAÇÃO DE EXAME PRODUTO"';

    procedure SetEmptySheet()
    begin
        EmptySheet := true;
    end;
}