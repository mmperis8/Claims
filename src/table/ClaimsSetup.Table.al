table 50321 "Claims Setup"
{
    Caption = 'Claims Setup', Comment = 'ESP="Conf. reclamaciones"';
    DataClassification = OrganizationIdentifiableInformation;
    DataPerCompany = false;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key', Comment = 'ESP="Clave Primaria"';
            DataClassification = OrganizationIdentifiableInformation;
        }
        field(2; "Claim Nos."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Claim No.', Comment = 'ESP="Nº Reclamación",PTG="Nº Reivindicação"';
            TableRelation = "No. Series";
        }
        field(3; "Default Return Reason"; Code[10])
        {
            Caption = 'Default Return Reason', Comment = 'ESP="Motivo devolución por defecto",PTG="Motivo devolução por defeito"';
            DataClassification = OrganizationIdentifiableInformation;
            TableRelation = "Return Reason";
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}