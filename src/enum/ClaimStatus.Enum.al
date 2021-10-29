enum 50322 "Claim Status"
{
    Extensible = true;

    value(0; "")
    {
    }
    value(1; "Vendor Pending")
    {
        Caption = 'Vendor Pending', Comment = 'ESP="Pte. Proveedor",PTG="Pte. Fornecedor"';
    }
    value(2; "Documentation Pending")
    {
        Caption = 'Documentation Pending', Comment = 'ESP="Pte. Documentación",PTG="Pte. Documentação"';
    }
    value(3; "Logistics Pending")
    {
        Caption = 'Logistics Pending', Comment = 'ESP="Pte. Logistica",PTG="Pte. Logistica"';
    }
    value(4; "Cr. Memo Receipt Pending")
    {
        Caption = 'Cr. Memo Receipt Pending', Comment = 'ESP="Pte. Recibir Abono",PTG="Pte. Receber Crédito"';
    }
    value(5; "Warranty Pending")
    {
        Caption = 'Warranty Pending', Comment = 'ESP="Pte. Garantías",PTG="Pte. Garantiaas"';
    }
}