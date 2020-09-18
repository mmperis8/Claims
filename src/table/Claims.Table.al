table 50320 "Claims"
{
    Caption = 'Claims', comment = 'ESP="Reclamaciones"';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Integer)
        {
            Caption = 'No.', comment = 'ESP="Nº"';
            DataClassification = CustomerContent;
        }

        field(5; "Source No."; Code[20])
        {
            Caption = 'Source No.', comment = 'ESP="Documento origen"';
            DataClassification = CustomerContent;
            NotBlank = true;
        }
        field(10; "Customer No."; Text[30])
        {
            Caption = 'Customer No.', comment = 'ESP="Nº Cliente"';
            DataClassification = CustomerContent;
            NotBlank = true;
        }
        field(15; "Wheel Item No."; Code[20])
        {
            Caption = 'Wheel Item No.', comment = 'ESP="Nº producto rueda"';
            DataClassification = CustomerContent;
            NotBlank = true;
        }
        field(20; "Plaque Code"; Code[20])
        {
            Caption = 'Plaque Code', comment = 'ESP="Cód. Matrícula"';
            DataClassification = CustomerContent;
            NotBlank = true;
        }
        field(25; "Reclamation date"; Date)
        {
            Caption = 'Reclamation date', comment = 'ESP="Fecha de reclamación"';
            DataClassification = Customercontent;
            NotBlank = true;
        }
        field(30; "M.E"; Code[50])
        {
            Caption = 'M.E', comment = 'ESP="M.E"';
            DataClassification = CustomerContent;
            NotBlank = true;
        }
        field(35; "Vehicle Kms."; Integer)
        {
            Caption = 'Vehicle Kms.', comment = 'ESP="Km. Uso"';
            DataClassification = CustomerContent;
            MinValue = 0;
        }

        field(40; "Mm. Start"; Decimal)
        {
            Caption = 'Mm. Start', comment = 'ESP="Mm. Inicio"';
            DataClassification = CustomerContent;
            MinValue = 0;
        }

        field(45; "Mm. Substract"; Decimal)
        {
            Caption = 'Mm. Substract', comment = 'ESP="Mm. Resto"';
            DataClassification = CustomerContent;
            NotBlank = true;
        }
        field(50; "Vendor Observations"; Text[100])
        {
            Caption = 'Vendor Observations', comment = 'ESP="Observaciones Proveedor"';
            DataClassification = CustomerContent;
        }
        field(55; "Customer Liquidation"; Boolean)
        {
            Caption = 'Customer Liquidation', comment = 'ESP="Liquidación Cliente"';
            DataClassification = ToBeClassified;
        }
        field(60; "Vendor Liquidation"; Boolean)
        {
            Caption = 'Vendor Liquidation', comment = 'ESP="Liquidación Proveedor"';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(No_PrimaryKey; "No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
        Claims: Record Claims;
    begin
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