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
            TableRelation = Customer;
        }
        field(15; "Wheel Item No."; Code[20])
        {
            Caption = 'Wheel Item No.', comment = 'ESP="Nº producto rueda",PTG="N.º do produto roda"';
            DataClassification = CustomerContent;
            TableRelation = Item;
        }
        field(20; "Plaque Code"; Code[20])
        {
            Caption = 'Plaque Code', comment = 'ESP="Cód. Matrícula",PTG="Código da matrícula"';
            DataClassification = CustomerContent;
            TableRelation = Plaque;
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
        field(35; "Vehicle Kms."; Decimal)
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
            TableRelation = "G/L Account";
        }
        field(80; "Location Code"; Code[20])
        {
            Caption = 'Location Code', comment = 'ESP="Cód. Almacén",PTG="Cód. Almacén"';
            DataClassification = CustomerContent;
            TableRelation = Location;
        }
        field(85; "Vehicle Type"; Enum "Vehicle Type")
        {
            Caption = 'Vehicle Type', comment = 'ESP="Tipo Vehiculo",PTG="Tipo de veículo"';
            DataClassification = CustomerContent;
        }
        field(90; "Coordinator Review"; Boolean)
        {
            Caption = 'Coordinator Review', comment = 'ESP="Rev. Coordinador",PTG="Rev. Coordenador"';
            DataClassification = CustomerContent;
        }
        field(95; "Coordinator Review Date"; Date)
        {
            Caption = 'Coordinator Review Date', comment = 'ESP="Fecha Revisión Coor.",PTG="Data de Revisão Coor."';
            DataClassification = CustomerContent;
        }
        field(100; "Manufacturer Review"; Boolean)
        {
            Caption = 'Manufacturer Review', comment = 'ESP="Rev. Fabricante",PTG="Rev. Fabricante"';
            DataClassification = CustomerContent;
        }
        field(105; "Manufacturer Review Date"; Date)
        {
            Caption = 'Manufacturer Review Date', comment = 'ESP="Fecha Revisión Fabr.",PTG="Fecha Revisión Fabr."';
            DataClassification = CustomerContent;
        }
        field(110; Company; Text[50])
        {
            Caption = 'Company', comment = 'ESP="Empresa",PTG="Empresa"';
            DataClassification = CustomerContent;
        }
        field(115; User; Code[20])
        {
            Caption = 'User', comment = 'ESP="Usuario",PTG="Usuario"';
            DataClassification = CustomerContent;
        }
        field(120; "Record Insert Date"; Date)
        {
            Caption = 'Record Insert Date', comment = 'ESP="Fecha Ins. Reg.",PTG="Fecha Ins. Reg."';
            DataClassification = CustomerContent;
        }
        field(125; Family; Code[20])
        {
            Caption = 'Family', comment = 'ESP="Familia",PTG="Familia"';
            DataClassification = CustomerContent;
            TableRelation = Family;
        }
        field(130; Brand; Code[20])
        {
            Caption = 'Brand', comment = 'ESP="Marca",PTG="Marca"';
            DataClassification = CustomerContent;
            TableRelation = Brand;
        }
        field(135; "Item Description"; Text[50])
        {
            Caption = 'Item Description', comment = 'ESP="Descripción producto",PTG="Descrição do produto"';
            DataClassification = CustomerContent;
        }
        field(140; "Customer Name"; Text[50])
        {
            Caption = 'Customer Name', comment = 'ESP="Nombre Cliente",PTG="Nome do cliente"';
            DataClassification = CustomerContent;
        }
        field(145; "Factory Report"; Text[100])
        {
            Caption = 'Factory Report', comment = 'ESP="Dictamen Fabrica",PTG="Relatório de Fábrica"';
            DataClassification = CustomerContent;
        }
        field(150; "Refusing Code"; Code[10])
        {
            Caption = 'Refusing Code', comment = 'ESP="Cód. Rechazo",PTG="Cód. Rejeição"';
            DataClassification = CustomerContent;
        }
        field(155; "Manufacturer AB Process"; Code[5])
        {
            Caption = 'Manufacturer AB Process', comment = 'ESP="Proce. AB. Fabricante",PTG="Proce. AB. Fabricante"';
            DataClassification = CustomerContent;
        }
        field(160; "Exam Reason"; Enum "Exam Reason")
        {
            Caption = 'Exam Reason', comment = 'ESP="Motivo Examen",PTG="Motivo Examen"';
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