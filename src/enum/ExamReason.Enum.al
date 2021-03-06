enum 50321 "Exam Reason"
{
    Extensible = true;

    value(0; "")
    {
    }
    value(1; "Irregular Wear")
    {
        Caption = 'Irregular Wear', Comment = 'ESP="Desgaste Irregular",PTG="Desgaste Irregular"';
    }
    value(2; "Case Degradation")
    {
        Caption = 'Case Degradation', Comment = 'ESP="Degradación Carcasa",PTG="Degradação da carcaça"';
    }
    value(3; "Heel Damage")
    {
        Caption = 'Heel Damage', Comment = 'ESP="Daños Talón",PTG="Dano Calcanhar"';
    }
    value(4; "Complaints Driving Behavior")
    {
        Caption = 'Complaints Driving Behavior', Comment = 'ESP="Quejas Compor. Conducción",PTG="Queixas Comportamento de Condução"';
    }
    value(5; Explosion)
    {
        Caption = 'Explosion', Comment = 'ESP="Explosión",PTG="Explosão"';
    }
    value(6; "Commercial Attention")
    {
        Caption = 'Commercial Attention', Comment = 'ESP="Atención Comercial",PTG="Atenção Comercial"';
    }
    value(7; Others)
    {
        Caption = 'Others', Comment = 'ESP="Otros",PTG="Otros"';
    }
}