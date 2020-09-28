table 50320 "Claims"
{
    Caption = 'Claims', comment = 'ESP="Reclamaciones",PTG="Reclamações"';
    DataClassification = CustomerContent;
    DataPerCompany = false;

    fields
    {
        field(1; "No."; Integer)
        {
            Caption = 'No.', comment = 'ESP="Nº",PTG="Nº"';
            DataClassification = CustomerContent;
        }

        field(5; "Source No."; Code[20])
        {
            Caption = 'Source No.', comment = 'ESP="Documento origen",PTG="Documento de origem"';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                Claims: Record Claims;
                SalesHeader: Record "Sales Header";
                NoSalesHdErr: Label 'There is no sales order with the specified number', comment = 'ESP="No exite ningún pedido venta con el número especificado",PTG="Não há nenhuma ordem de venda com o número especificado"';
            begin
                if not SalesHeader.Get(SalesHeader."Document Type"::Order, "Source No.") then
                    Error(NoSalesHdErr);

                Claims.SetRange("Source No.", SalesHeader."No.");
                if Claims.FindLast() then
                    "Source Line No." := 10000 + Claims."Source Line No."
                else
                    "Source Line No." := 10000;
            end;
        }
        field(6; "Source Line No."; Integer)
        {
            Caption = 'Source Line No.', comment = 'ESP="Línea documento origen",PTG="Linha de documento de origem"';
            DataClassification = CustomerContent;
        }
        field(10; "Customer No."; Text[30])
        {
            Caption = 'Customer No.', comment = 'ESP="Nº Cliente",PTG="Nº de cliente"';
            DataClassification = CustomerContent;
        }
        field(15; "Wheel Item No."; Code[20])
        {
            Caption = 'Wheel Item No.', comment = 'ESP="Nº producto rueda",PTG="N.º do produto roda"';
            DataClassification = CustomerContent;
        }
        field(20; "Plaque Code"; Code[20])
        {
            Caption = 'Plaque Code', comment = 'ESP="Cód. Matrícula",PTG="Código da matrícula"';
            DataClassification = CustomerContent;
        }
        field(25; "Reclamation date"; Date)
        {
            Caption = 'Reclamation date', comment = 'ESP="Fecha de reclamación",PTG="Data da queixa"';
            DataClassification = Customercontent;
        }
        field(30; "M.E"; Code[50])
        {
            Caption = 'M.E', comment = 'ESP="M.E",PTG="M.E"';
            DataClassification = CustomerContent;
        }
        field(35; "Vehicle Kms."; Integer)
        {
            Caption = 'Vehicle Kms.', comment = 'ESP="Km. Uso",PTG="Km. Utilização"';
            DataClassification = CustomerContent;
            MinValue = 0;
        }
        field(40; "Mm. Start"; Decimal)
        {
            Caption = 'Mm. Start', comment = 'ESP="Mm. Inicio",PTG="Mm. Início"';
            DataClassification = CustomerContent;
            MinValue = 0;
        }
        field(45; "Mm. Substract"; Decimal)
        {
            Caption = 'Mm. Substract', comment = 'ESP="Mm. Resto",PTG="Mm. Descanso"';
            DataClassification = CustomerContent;
        }
        field(50; "Vendor Observations"; Text[100])
        {
            Caption = 'Vendor Observations', comment = 'ESP="Observaciones Proveedor",PTG="Observações Fornecedor"';
            DataClassification = CustomerContent;
        }
        field(55; "Customer Liquidation"; Boolean)
        {
            Caption = 'Customer Liquidation', comment = 'ESP="Liquidación Cliente",PTG="Liquidação de Clientes"';
            DataClassification = CustomerContent;
        }
        field(60; "Vendor Liquidation"; Boolean)
        {
            Caption = 'Vendor Liquidation', comment = 'ESP="Liquidación Proveedor",PTG="Assentamento de Vendedores"';
            DataClassification = CustomerContent;
        }
        field(65; "Vendor Cr Memo No."; Code[20])
        {
            Caption = 'Vendor Cr Memo No', comment = 'ESP="Nº Abono Proveedor",PTG="Número da nota de crédito do fornecedor"';
            DataClassification = CustomerContent;
        }
        field(70; "Vendor Cr Memo Amount"; Decimal)
        {
            Caption = 'Vendor Cr Memo Amount', comment = 'ESP="Importe Abono Proveedor",PTG="Montante da nota de crédito Vendedor"';
            DataClassification = CustomerContent;
        }
        field(75; "Vendor Account"; Code[20])
        {
            Caption = 'Vendor Account', comment = 'ESP="Cta Proveedor",PTG="Conta Fornecedor"';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(No_PrimaryKey; "No.", "Source No.", "Source Line No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
        Claims: Record Claims;
    begin

        Clear(Claims);
        if Claims.FindLast() then
            "No." := Claims."No." + 1
        else
            "No." := 1;

        if "Reclamation date" = 0D then
            "Reclamation date" := WorkDate();

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}