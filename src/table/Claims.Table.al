table 50320 "Claims"
{
    Caption = 'Claims', Comment = 'ESP="Reclamaciones",PTG="Reclamações"';
    DataClassification = CustomerContent;
    DataPerCompany = false;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.', Comment = 'ESP="Nº",PTG="Nº"';
            DataClassification = CustomerContent;
        }

        field(5; "Source No."; Code[20])
        {
            Caption = 'Source No.', Comment = 'ESP="Documento origen",PTG="Documento de origem"';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                Claims: Record Claims;
                SalesHeader: Record "Sales Header";
                NoSalesHdErr: Label 'There is no sales order with the specified number', Comment = 'ESP="No exite ningún pedido venta con el número especificado",PTG="Não há nenhuma ordem de venda com o número especificado"';
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
            Caption = 'Source Line No.', Comment = 'ESP="Línea documento origen",PTG="Linha de documento de origem"';
            DataClassification = CustomerContent;
        }
        field(10; "Customer No."; Text[30])
        {
            Caption = 'Customer No.', Comment = 'ESP="Nº Cliente",PTG="Nº de cliente"';
            DataClassification = CustomerContent;
            TableRelation = Customer;
        }
        field(15; "Wheel Item No."; Code[20])
        {
            Caption = 'Wheel Item No.', Comment = 'ESP="Nº producto rueda",PTG="N.º do produto roda"';
            DataClassification = CustomerContent;
            TableRelation = Item;
        }
        field(20; "Plaque Code"; Code[20])
        {
            Caption = 'Plaque Code', Comment = 'ESP="Cód. Matrícula",PTG="Código da matrícula"';
            DataClassification = CustomerContent;
            TableRelation = Plaque;
        }
        field(25; "Reclamation date"; Date)
        {
            Caption = 'Reclamation date', Comment = 'ESP="Fecha de reclamación",PTG="Data da queixa"';
            DataClassification = Customercontent;
        }
        field(30; "M.E"; Code[50])
        {
            Caption = 'M.E', Comment = 'ESP="M.E",PTG="M.E"';
            DataClassification = CustomerContent;
        }
        field(35; "Vehicle Kms."; Decimal)
        {
            Caption = 'Vehicle Kms.', Comment = 'ESP="Km. Uso",PTG="Km. Utilização"';
            DataClassification = CustomerContent;
            MinValue = 0;
        }
        field(40; "Mm. Start"; Decimal)
        {
            Caption = 'Mm. Start', Comment = 'ESP="Mm. Inicio",PTG="Mm. Início"';
            DataClassification = CustomerContent;
            MinValue = 0;
        }
        field(45; "Mm. Substract"; Decimal)
        {
            Caption = 'Mm. Substract', Comment = 'ESP="Mm. Resto",PTG="Mm. Descanso"';
            DataClassification = CustomerContent;
        }
        field(50; "Vendor Observations"; Text[100])
        {
            Caption = 'Vendor Observations', Comment = 'ESP="Observaciones Proveedor",PTG="Observações Fornecedor"';
            DataClassification = CustomerContent;
        }
        field(55; "Customer Liquidation"; Boolean)
        {
            Caption = 'Customer Liquidation', Comment = 'ESP="Liquidación Cliente",PTG="Liquidação de Clientes"';
            DataClassification = CustomerContent;
        }
        field(60; "Vendor Liquidation"; Boolean)
        {
            Caption = 'Vendor Liquidation', Comment = 'ESP="Liquidación Proveedor",PTG="Assentamento de Vendedores"';
            DataClassification = CustomerContent;
        }
        field(65; "Vendor Cr Memo No."; Code[20])
        {
            Caption = 'Vendor Cr Memo No', Comment = 'ESP="Nº Abono Proveedor",PTG="Número da nota de crédito do fornecedor"';
            DataClassification = CustomerContent;
        }
        field(70; "Vendor Cr Memo Amount"; Decimal)
        {
            Caption = 'Vendor Cr Memo Amount', Comment = 'ESP="Importe Abono Proveedor",PTG="Montante da nota de crédito Vendedor"';
            DataClassification = CustomerContent;
        }
        field(75; "Vendor Account"; Code[20])
        {
            Caption = 'Vendor Account', Comment = 'ESP="Cta Proveedor",PTG="Conta Fornecedor"';
            DataClassification = CustomerContent;
            TableRelation = "G/L Account";
        }
        field(80; "Location Code"; Code[20])
        {
            Caption = 'Location Code', Comment = 'ESP="Cód. Almacén",PTG="Cód. Almacén"';
            DataClassification = CustomerContent;
            TableRelation = Location;
        }
        field(85; "Vehicle Type"; Enum "Vehicle Type")
        {
            Caption = 'Vehicle Type', Comment = 'ESP="Tipo Vehiculo",PTG="Tipo de veículo"';
            DataClassification = CustomerContent;
        }
        field(90; "Coordinator Review"; Boolean)
        {
            Caption = 'Coordinator Review', Comment = 'ESP="Rev. Coordinador",PTG="Rev. Coordenador"';
            DataClassification = CustomerContent;
        }
        field(95; "Coordinator Review Date"; Date)
        {
            Caption = 'Coordinator Review Date', Comment = 'ESP="Fecha Revisión Coor.",PTG="Data de Revisão Coor."';
            DataClassification = CustomerContent;
        }
        field(100; "Manufacturer Review"; Boolean)
        {
            Caption = 'Manufacturer Review', Comment = 'ESP="Rev. Fabricante",PTG="Rev. Fabricante"';
            DataClassification = CustomerContent;
        }
        field(105; "Manufacturer Review Date"; Date)
        {
            Caption = 'Manufacturer Review Date', Comment = 'ESP="Fecha Revisión Fabr.",PTG="Fecha Revisión Fabr."';
            DataClassification = CustomerContent;
        }
        field(110; Company; Text[50])
        {
            Caption = 'Company', Comment = 'ESP="Empresa",PTG="Empresa"';
            DataClassification = CustomerContent;
        }
        field(115; User; Code[20])
        {
            Caption = 'User', Comment = 'ESP="Usuario",PTG="Usuario"';
            DataClassification = CustomerContent;
        }
        field(120; "Record Insert Date"; Date)
        {
            Caption = 'Record Insert Date', Comment = 'ESP="Fecha Ins. Reg.",PTG="Fecha Ins. Reg."';
            DataClassification = CustomerContent;
        }
        field(125; Family; Code[15])
        {
            Caption = 'Family', Comment = 'ESP="Familia",PTG="Familia"';
            DataClassification = CustomerContent;
            TableRelation = Family;
        }
        field(130; Brand; Code[15])
        {
            Caption = 'Brand', Comment = 'ESP="Marca",PTG="Marca"';
            DataClassification = CustomerContent;
            TableRelation = Brand;
        }
        field(135; "Item Description"; Text[50])
        {
            Caption = 'Item Description', Comment = 'ESP="Descripción producto",PTG="Descrição do produto"';
            DataClassification = CustomerContent;
        }
        field(140; "Customer Name"; Text[50])
        {
            Caption = 'Customer Name', Comment = 'ESP="Nombre Cliente",PTG="Nome do cliente"';
            DataClassification = CustomerContent;
        }
        field(145; "Factory Report"; Text[100])
        {
            Caption = 'Factory Report', Comment = 'ESP="Dictamen Fabrica",PTG="Relatório de Fábrica"';
            DataClassification = CustomerContent;
        }
        field(150; "Refusing Code"; Code[10])
        {
            Caption = 'Refusing Code', Comment = 'ESP="Cód. Rechazo",PTG="Cód. Rejeição"';
            DataClassification = CustomerContent;
        }
        field(155; "Manufacturer AB Process"; Code[5])
        {
            Caption = 'Manufacturer AB Process', Comment = 'ESP="Proce. AB. Fabricante",PTG="Proce. AB. Fabricante"';
            DataClassification = CustomerContent;
        }
        field(160; "Exam Reason"; Enum "Exam Reason")
        {
            Caption = 'Exam Reason', Comment = 'ESP="Motivo Examen",PTG="Motivo Examen"';
            DataClassification = CustomerContent;
        }
        field(165; Demonstrations; Code[10])
        {
            Caption = 'Demonstartions', Comment = 'ESP="Manifestaciones",PTG="Manifestações"';
            DataClassification = CustomerContent;
        }
        field(170; "Housing Brand"; Text[30])
        {
            Caption = 'Housing Brand', Comment = 'ESP="Marca Carcasa",PTG="Marca Carcaça"';
            DataClassification = CustomerContent;
        }
        field(175; "Housing Model"; Code[30])
        {
            Caption = 'Housing Model', Comment = 'ESP="Modelo Carcasa",PTG="Modelo Carcaça"';
            DataClassification = CustomerContent;
        }
        field(180; DOT; Text[20])
        {
            Caption = 'DOT', Comment = 'ESP="DOT",PTG="DOT"';
            DataClassification = CustomerContent;
        }
        field(185; "Vehicle Brand"; Text[30])
        {
            Caption = 'Vehicle Brand', Comment = 'ESP="Marca Vehículo",PTG="Marca de veículo"';
            DataClassification = CustomerContent;
        }
        field(190; "Vehicle Model"; Text[60])
        {
            Caption = 'Vehicle Model', Comment = 'ESP="Modelo Vehículo",PTG="Model veículo"';
            DataClassification = CustomerContent;
        }
        field(195; "Registration date"; Date)
        {
            Caption = 'Registration date', Comment = 'ESP="Fecha matriculación",PTG="Data de registo"';
            DataClassification = CustomerContent;
        }
        field(200; "Frame No."; Text[30])
        {
            Caption = 'Frame No.', Comment = 'ESP="Nº bastidor",PTG="Nº moldura"';
            DataClassification = CustomerContent;
        }
        field(205; "Vehicle total km."; Integer)
        {
            Caption = 'Vehicle total km.', Comment = 'ESP="Km. totales vehículo",PTG="Total quilómetros veículo"';
            DataClassification = CustomerContent;
        }
        field(210; Subscriber; Decimal)
        {
            Caption = 'Subscriber', Comment = 'ESP="Abonado",PTG="Assinante"';
            DataClassification = CustomerContent;
        }
        field(215; "Received in NLLE"; Boolean)
        {
            Caption = 'Received in NLLE', Comment = 'ESP="Recibido en NLLE",PTG="Recebido NLLE"';
            DataClassification = CustomerContent;
        }
        field(220; "Management with incidence"; Boolean)
        {
            Caption = 'Management with incidence', Comment = 'ESP="Gestión con incidencia",PTG="Gestão con incidência"';
            DataClassification = CustomerContent;
        }
        field(225; "Claim Status"; Boolean)
        {
            Caption = 'Claim Status', Comment = 'ESP="Estado reclamación",PTG="Estado de Reivindicação"';
            DataClassification = CustomerContent;
        }
        field(230; "Shipment Address"; Code[10])
        {
            Caption = 'Shipment Address', Comment = 'ESP="Dirección de envío",PTG="Endereço de envio"';
            DataClassification = CustomerContent;
        }
        field(235; Status; Enum "Claim Status")
        {
            Caption = 'Status', Comment = 'ESP="Estado",PTG="Status"';
            DataClassification = CustomerContent;
        }
        field(240; "Customer Account"; Code[10])
        {
            Caption = 'Customer Account', Comment = 'ESP="Cta. Cliente",PTG="Cta Cliente"';
            DataClassification = CustomerContent;
        }
        field(245; "Associated Claim No."; Integer)
        {
            Caption = 'Associated Claim No.', Comment = 'ESP="Nº Reclamación vinculada",PTG="Nº Reclamação ligado"';
            DataClassification = CustomerContent;
        }
        field(250; "Warranty Observations"; Text[100])
        {
            Caption = 'Warranty Observations', Comment = 'ESP="Observaciones garantías",PTG="Observaçoes garantias"';
            DataClassification = CustomerContent;
        }
        field(255; "Tire Id."; Text[30])
        {
            Caption = 'Tire Id.', Comment = 'ESP="Matrícula cubierta",PTG="Id. pneu"';
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
        ClaimSetup: Record "Claims Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        if "No." = '' then begin
            ClaimSetup.Get();
            ClaimSetup.TestField("Claim Nos.");
            "No." := NoSeriesMgt.GetNextNo(ClaimSetup."Claim Nos.", Today(), true);
        end;

        if "Reclamation date" = 0D then
            "Reclamation date" := WorkDate();
    end;
}