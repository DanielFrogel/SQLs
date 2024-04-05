SELECT 
      (CASE WHEN NF.TIPO = 'S' THEN (C.CNPJ) ELSE
             (F.CNPJ) END) CNPJ,
       (CASE WHEN NF.TIPO = 'S' THEN (C.NOME) ELSE
             (F.NOME) END) NOME,
      SUM(CASE WHEN NF.TIPO = 'S' THEN NF.TOTAL_PRODUTOS ELSE NF.TOTAL_PRODUTOS* -1 END) AS TOTAL_PRODUTOS, 
      SUM(CASE WHEN NF.TIPO = 'S' THEN NF.VALOR_SERVICOS ELSE NF.VALOR_SERVICOS * -1 END) AS VALOR_SERVICOS,
      SUM(CASE WHEN NF.TIPO = 'S' THEN NF.VALOR_ISS ELSE NF.VALOR_ISS * -1 END) AS VALOR_ISS,
      SUM(CASE WHEN NF.TIPO = 'S' THEN NF.BASE_ICMS ELSE NF.BASE_ICMS * -1 END) AS BASE_ICMS,
      SUM(CASE WHEN NF.TIPO = 'S' THEN NF.VALOR_ICMS ELSE NF.VALOR_ICMS * -1 END) AS VALOR_ICMS,
      SUM(CASE WHEN NF.TIPO = 'S' THEN NF.BASE_IPI ELSE NF.BASE_IPI * -1 END) AS BASE_IPI,
      SUM(CASE WHEN NF.TIPO = 'S' THEN NF.VALOR_IPI ELSE NF.VALOR_IPI * -1 END) AS VALOR_IPI,
	SUM(CASE WHEN NF.TIPO = 'S' THEN NF.VALOR_TOTAL_NOTA ELSE  NF.VALOR_TOTAL_NOTA* -1 END) AS VALOR_TOTAL_NOTA	
FROM NOTAS NF

  LEFT JOIN CLIENTES C ON (C.CODIGO = NF.CLIENTE AND NF.TIPO = 'S')
  LEFT JOIN FORNECEDORES F ON (F.CODIGO = NF.CLIENTE AND NF.TIPO = 'E')

 WHERE NF.NUMERO BETWEEN :NINI AND :NFIM
   AND NF.SERIE  BETWEEN :SINI AND :SFIM
   AND NOT COALESCE(NF.GERADO_NFE,'X') IN ('D','C','I')
   AND COALESCE(NF.CANCELADA,'N') <> 'S'   
   AND NF.EMISSAO BETWEEN :DINI AND :DFIM
   AND (NF.EMPRESA = :EMPRESA OR CAST ('' AS VARCHAR(3)) = :EMPRESA)
   AND COALESCE(NF.VENDEDOR, '') LIKE :VENDEDOR || '%'
   AND NF.ID_TIPO_NOTA IN (1,3,6)

GROUP BY 1,2
ORDER BY &ORDEM

-- PARAMETER:'EMPRESA';TYPE:'TEXT';DESCRIPTION:'Empresa (em branco lista todas)';SIZE:003;DEFAULT:'EMP';ZEROS:'NAO'
-- PARAMETER:'NINI';TYPE:'TEXT';DESCRIPTION:'Número inicial';SIZE:006;FORMAT:'######;1; ';DEFAULT:'000001';ZEROS:'SIM'
-- PARAMETER:'NFIM';TYPE:'TEXT';DESCRIPTION:'Número final';SIZE:006;FORMAT:'######;1; ';DEFAULT:'999999';ZEROS:'SIM'
-- PARAMETER:'SINI';TYPE:'TEXT';DESCRIPTION:'Série inicial';SIZE:003;DEFAULT:'1';ZEROS:'NAO'
-- PARAMETER:'SFIM';TYPE:'TEXT';DESCRIPTION:'Série final';SIZE:003;DEFAULT:'999';ZEROS:'NAO'
-- PARAMETER:'DINI';TYPE:'DATE';DESCRIPTION:'Data de emissão inicial';DEFAULT:'HOJE'
-- PARAMETER:'DFIM';TYPE:'DATE';DESCRIPTION:'Data de emissão final';DEFAULT:'HOJE'
-- PARAMETER:'VENDEDOR';TYPE:'TEXT';DESCRIPTION:'Vendedor';SIZE:003;BUTTON:'VENDEDORES';ZEROS:'NAO'

-- ORDER:'10 DESC,2';DESCRIPTION:'Valor'A seleção será realizada com base nos tipos de nota 1 e 6, enquanto o tipo 3 será descontado do total.<?xml version="1.0" encoding="utf-8" standalone="no"?>
<TfrxReport Version="6.9.14" DotMatrixReport="False" IniFile="c:\wle_sistemas\Fast Reports" PreviewOptions.Buttons="4095" PreviewOptions.Zoom="1" PrintOptions.Printer="Padr?o" PrintOptions.PrintOnSheet="0" ReportOptions.CreateDate="41383,4842004282" ReportOptions.Description.Text="" ReportOptions.LastChange="45387,4742623843" ScriptLanguage="PascalScript" ScriptText.Text="begin&#13;&#10;&#13;&#10;end.">
  <Datasets>
    <item DataSet="DataSetMaster" DataSetName="SQL Mestre"/>
  </Datasets>
  <TfrxDataPage Name="Data" HGuides.Text="" VGuides.Text="" Height="1000" Left="0" Top="0" Width="1000"/>
  <TfrxReportPage Name="Page1" HGuides.Text="" VGuides.Text="" Orientation="poLandscape" PaperWidth="297" PaperHeight="210" PaperSize="9" LeftMargin="10,00125" RightMargin="10,00125" TopMargin="10,00125" BottomMargin="10,00125" ColumnWidth="0" ColumnPositions.Text="" Frame.Typ="0" MirrorMode="0">
    <TfrxMasterData Name="MasterData1" FillType="ftBrush" FillGap.Top="0" FillGap.Left="0" FillGap.Bottom="0" FillGap.Right="0" Frame.Typ="0" Height="15,87401575" Left="0" Top="151,1812" Width="1046,920361175" ColumnWidth="0" ColumnGap="0" DataSet="DataSetMaster" DataSetName="SQL Mestre" RowCount="0">
      <TfrxMemoView Name="SQLMestreNOME" AllowVectorExport="True" Left="5,85034" Top="0" Width="345,07091252" Height="13,98425197" DataSet="DataSetMaster" DataSetName="SQL Mestre" Font.Charset="1" Font.Color="0" Font.Height="-11" Font.Name="Arial" Font.Style="0" Frame.Typ="0" ParentFont="False" Text="[SQL Mestre.&#34;NOME&#34;]"/>
      <TfrxMemoView Name="Memo4" AllowVectorExport="True" Left="530,06299213" Top="0" Width="72,56692425" Height="13,9842519685039" DataField="VALOR_SERVICOS" DataSet="DataSetMaster" DataSetName="SQL Mestre" DisplayFormat.DecimalSeparator="," DisplayFormat.FormatStr="###,###,##0.00" DisplayFormat.Kind="fkNumeric" Font.Charset="1" Font.Color="0" Font.Height="-11" Font.Name="Arial" Font.Style="0" Frame.Typ="0" HAlign="haRight" ParentFont="False" Text="[SQL Mestre.&#34;VALOR_SERVICOS&#34;]"/>
      <TfrxMemoView Name="Memo14" AllowVectorExport="True" Left="604,07874016" Top="0" Width="72,56692425" Height="13,9842519685039" DataField="VALOR_ISS" DataSet="DataSetMaster" DataSetName="SQL Mestre" DisplayFormat.DecimalSeparator="," DisplayFormat.FormatStr="###,###,##0.00" DisplayFormat.Kind="fkNumeric" Font.Charset="1" Font.Color="0" Font.Height="-11" Font.Name="Arial" Font.Style="0" Frame.Typ="0" HAlign="haRight" ParentFont="False" Text="[SQL Mestre.&#34;VALOR_ISS&#34;]"/>
      <TfrxMemoView Name="Memo15" AllowVectorExport="True" Left="678,09448819" Top="0" Width="72,56692425" Height="13,9842519685039" DataField="BASE_ICMS" DataSet="DataSetMaster" DataSetName="SQL Mestre" DisplayFormat.DecimalSeparator="," DisplayFormat.FormatStr="###,###,##0.00" DisplayFormat.Kind="fkNumeric" Font.Charset="1" Font.Color="0" Font.Height="-11" Font.Name="Arial" Font.Style="0" Frame.Typ="0" HAlign="haRight" ParentFont="False" Text="[SQL Mestre.&#34;BASE_ICMS&#34;]"/>
      <TfrxMemoView Name="Memo16" AllowVectorExport="True" Left="752,11023622" Top="0" Width="72,56692425" Height="13,9842519685039" DataField="VALOR_ICMS" DataSet="DataSetMaster" DataSetName="SQL Mestre" DisplayFormat.DecimalSeparator="," DisplayFormat.FormatStr="###,###,##0.00" DisplayFormat.Kind="fkNumeric" Font.Charset="1" Font.Color="0" Font.Height="-11" Font.Name="Arial" Font.Style="0" Frame.Typ="0" HAlign="haRight" ParentFont="False" Text="[SQL Mestre.&#34;VALOR_ICMS&#34;]"/>
      <TfrxMemoView Name="Memo17" AllowVectorExport="True" Left="826,12598425" Top="0" Width="72,56692425" Height="13,9842519685039" DataField="BASE_IPI" DataSet="DataSetMaster" DataSetName="SQL Mestre" DisplayFormat.DecimalSeparator="," DisplayFormat.FormatStr="###,###,##0.00" DisplayFormat.Kind="fkNumeric" Font.Charset="1" Font.Color="0" Font.Height="-11" Font.Name="Arial" Font.Style="0" Frame.Typ="0" HAlign="haRight" ParentFont="False" Text="[SQL Mestre.&#34;BASE_IPI&#34;]"/>
      <TfrxMemoView Name="Memo18" AllowVectorExport="True" Left="900,14173228" Top="0" Width="72,56692425" Height="13,9842519685039" DataField="VALOR_IPI" DataSet="DataSetMaster" DataSetName="SQL Mestre" DisplayFormat.DecimalSeparator="," DisplayFormat.FormatStr="###,###,##0.00" DisplayFormat.Kind="fkNumeric" Font.Charset="1" Font.Color="0" Font.Height="-11" Font.Name="Arial" Font.Style="0" Frame.Typ="0" HAlign="haRight" ParentFont="False" Text="[SQL Mestre.&#34;VALOR_IPI&#34;]"/>
      <TfrxMemoView Name="Memo19" AllowVectorExport="True" Left="973,77952756" Top="0" Width="72,56692425" Height="13,9842519685039" DataField="VALOR_TOTAL_NOTA" DataSet="DataSetMaster" DataSetName="SQL Mestre" DisplayFormat.DecimalSeparator="," DisplayFormat.FormatStr="###,###,##0.00" DisplayFormat.Kind="fkNumeric" Font.Charset="1" Font.Color="0" Font.Height="-11" Font.Name="Arial" Font.Style="0" Frame.Typ="0" HAlign="haRight" ParentFont="False" Text="[SQL Mestre.&#34;VALOR_TOTAL_NOTA&#34;]"/>
      <TfrxMemoView Name="Memo20" AllowVectorExport="True" Left="456,04724409" Top="0" Width="72,56692425" Height="13,98425197" DataField="TOTAL_PRODUTOS" DataSet="DataSetMaster" DataSetName="SQL Mestre" DisplayFormat.DecimalSeparator="," DisplayFormat.FormatStr="###,###,##0.00" DisplayFormat.Kind="fkNumeric" Font.Charset="1" Font.Color="0" Font.Height="-11" Font.Name="Arial" Font.Style="0" Frame.Typ="0" HAlign="haRight" ParentFont="False" Text="[SQL Mestre.&#34;TOTAL_PRODUTOS&#34;]"/>
      <TfrxMemoView Name="Memo21" AllowVectorExport="True" Left="352,61441" Top="0" Width="102,04724409" Height="13,98425197" DataField="CNPJ" DataSet="DataSetMaster" DataSetName="SQL Mestre" Font.Charset="1" Font.Color="0" Font.Height="-11" Font.Name="Arial" Font.Style="0" Frame.Typ="0" ParentFont="False" Text="[SQL Mestre.&#34;CNPJ&#34;]"/>
    </TfrxMasterData>
    <TfrxPageFooter Name="PageFooter1" FillType="ftBrush" FillGap.Top="0" FillGap.Left="0" FillGap.Bottom="0" FillGap.Right="0" Frame.Typ="0" Height="20" Left="0" Top="272,12616" Width="1046,920361175">
      <TfrxMemoView Name="TotalPages" AllowVectorExport="True" Left="941,50433" Top="0,10236465" Width="102,04731" Height="18,89765" Font.Charset="1" Font.Color="-16777208" Font.Height="-13" Font.Name="Arial" Font.Style="0" Frame.Typ="0" HAlign="haRight" ParentFont="False" Text="[Page#] / [TotalPages#]"/>
    </TfrxPageFooter>
    <TfrxPageHeader Name="PageHeader1" FillType="ftBrush" FillGap.Top="0" FillGap.Left="0" FillGap.Bottom="0" FillGap.Right="0" Frame.Typ="0" Height="71,81107" Left="0" Top="18,89765" Width="1046,920361175">
      <TfrxMemoView Name="Memo2" AllowVectorExport="True" Left="775,76407" Top="22,67718" Width="98,48825" Height="18,89765" Font.Charset="1" Font.Color="0" Font.Height="-13" Font.Name="Arial" Font.Style="0" Frame.Typ="0" HAlign="haRight" ParentFont="False" Text="Data:"/>
      <TfrxMemoView Name="Date" AllowVectorExport="True" Left="877,81138" Top="22,67718" Width="90,92919" Height="18,89765" Font.Charset="1" Font.Color="-16777208" Font.Height="-13" Font.Name="Arial" Font.Style="0" Frame.Typ="0" ParentFont="False" Text="[Date]"/>
      <TfrxMemoView Name="Time" AllowVectorExport="True" Left="972,29963" Top="22,67718" Width="72,03154" Height="18,89765" Font.Charset="1" Font.Color="0" Font.Height="-13" Font.Name="Arial" Font.Style="0" Frame.Typ="0" HAlign="haRight" ParentFont="False" Text="[Time]"/>
      <TfrxLineView Name="Line2" AllowVectorExport="True" Left="3,77953" Top="45,35436" Width="1038,55164" Height="0" Color="0" Frame.Typ="4"/>
      <TfrxMemoView Name="RetornaEmpresa" AllowVectorExport="True" Left="7,55906" Top="22,67718" Width="434,64595" Height="18,89765" Frame.Typ="0" Text="[RetornaEmpresa('RELATORIO')]"/>
      <TfrxMemoView Name="RetornaEmpresa1" AllowVectorExport="True" Left="7,55906" Top="0" Width="438,42548" Height="18,89765" Font.Charset="1" Font.Color="0" Font.Height="-13" Font.Name="Arial" Font.Style="1" Frame.Typ="0" ParentFont="False" Text="[RetornaEmpresa('DESCRICAO')]"/>
      <TfrxMemoView Name="RetornaEmpresa2" AllowVectorExport="True" Left="775,76407" Top="0" Width="268,5671" Height="18,89765" Frame.Typ="0" HAlign="haRight" Text="[RetornaEmpresa('NUMEROINSCRICAO')]"/>
      <TfrxMemoView Name="Memo3" AllowVectorExport="True" Left="5,85034" Top="52" Width="345,07091252" Height="16" Font.Charset="1" Font.Color="0" Font.Height="-11" Font.Name="Arial" Font.Style="0" Frame.Typ="8" ParentFont="False" Text="Nome"/>
      <TfrxMemoView Name="Memo5" AllowVectorExport="True" Left="456,047244094488" Top="52" Width="72,44094" Height="16" Font.Charset="1" Font.Color="0" Font.Height="-11" Font.Name="Arial" Font.Style="0" Frame.Typ="8" HAlign="haRight" ParentFont="False" Text="Total produtos"/>
      <TfrxMemoView Name="Memo6" AllowVectorExport="True" Left="530,062992125984" Top="52" Width="72,44094" Height="16" Font.Charset="1" Font.Color="0" Font.Height="-11" Font.Name="Arial" Font.Style="0" Frame.Typ="8" HAlign="haRight" ParentFont="False" Text="Total serviÃ§os"/>
      <TfrxMemoView Name="Memo7" AllowVectorExport="True" Left="604,07874015748" Top="52" Width="72,44094" Height="16" Font.Charset="1" Font.Color="0" Font.Height="-11" Font.Name="Arial" Font.Style="0" Frame.Typ="8" HAlign="haRight" ParentFont="False" Text="Valor ISS"/>
      <TfrxMemoView Name="Memo8" AllowVectorExport="True" Left="678,094488188976" Top="52" Width="72,44094" Height="16" Font.Charset="1" Font.Color="0" Font.Height="-11" Font.Name="Arial" Font.Style="0" Frame.Typ="8" HAlign="haRight" ParentFont="False" Text="Base ICMS"/>
      <TfrxMemoView Name="Memo9" AllowVectorExport="True" Left="752,110236220472" Top="52" Width="72,44094" Height="16" Font.Charset="1" Font.Color="0" Font.Height="-11" Font.Name="Arial" Font.Style="0" Frame.Typ="8" HAlign="haRight" ParentFont="False" Text="Valor ICMS"/>
      <TfrxMemoView Name="Memo10" AllowVectorExport="True" Left="826,125984251969" Top="52" Width="72,44094" Height="16" Font.Charset="1" Font.Color="0" Font.Height="-11" Font.Name="Arial" Font.Style="0" Frame.Typ="8" HAlign="haRight" ParentFont="False" Text="Base IPI"/>
      <TfrxMemoView Name="Memo11" AllowVectorExport="True" Left="900,141732283465" Top="52" Width="72,5669242519685" Height="16" Font.Charset="1" Font.Color="0" Font.Height="-11" Font.Name="Arial" Font.Style="0" Frame.Typ="8" HAlign="haRight" ParentFont="False" Text="Valor IPI"/>
      <TfrxMemoView Name="Memo12" AllowVectorExport="True" Left="973,779527559055" Top="52" Width="72,5669242519685" Height="16" Font.Charset="1" Font.Color="0" Font.Height="-11" Font.Name="Arial" Font.Style="0" Frame.Typ="8" HAlign="haRight" ParentFont="False" Text="Valor total"/>
      <TfrxMemoView Name="Memo22" AllowVectorExport="True" Left="352,61441" Top="51,91342" Width="102,04724409" Height="16" Font.Charset="1" Font.Color="0" Font.Height="-11" Font.Name="Arial" Font.Style="0" Frame.Typ="8" ParentFont="False" Text="CNPJ / CPF"/>
    </TfrxPageHeader>
    <TfrxReportSummary Name="ReportSummary1" FillType="ftBrush" FillGap.Top="0" FillGap.Left="0" FillGap.Bottom="0" FillGap.Right="0" Frame.Typ="0" Height="22,67718" Left="0" Top="226,7718" Width="1046,920361175">
      <TfrxSysMemoView Name="SysMemo10" AllowVectorExport="True" Left="456,04724409" Top="4" Width="72,44094" Height="12" DisplayFormat.DecimalSeparator="," DisplayFormat.FormatStr="###,###,##0.00" DisplayFormat.Kind="fkNumeric" Font.Charset="1" Font.Color="0" Font.Height="-11" Font.Name="Arial" Font.Style="1" Frame.Typ="4" HAlign="haRight" ParentFont="False" Text="[SUM(&#60;SQL Mestre.&#34;TOTAL_PRODUTOS&#34;&#62;,MasterData1,2)]"/>
      <TfrxSysMemoView Name="SysMemo11" AllowVectorExport="True" Left="530,06299213" Top="4" Width="72,44094" Height="12" DisplayFormat.DecimalSeparator="," DisplayFormat.FormatStr="###,###,##0.00" DisplayFormat.Kind="fkNumeric" Font.Charset="1" Font.Color="0" Font.Height="-11" Font.Name="Arial" Font.Style="1" Frame.Typ="4" HAlign="haRight" ParentFont="False" Text="[SUM(&#60;SQL Mestre.&#34;VALOR_SERVICOS&#34;&#62;,MasterData1,2)]"/>
      <TfrxSysMemoView Name="SysMemo12" AllowVectorExport="True" Left="604,07874016" Top="4" Width="72,44094" Height="12" DisplayFormat.DecimalSeparator="," DisplayFormat.FormatStr="###,###,##0.00" DisplayFormat.Kind="fkNumeric" Font.Charset="1" Font.Color="0" Font.Height="-11" Font.Name="Arial" Font.Style="1" Frame.Typ="4" HAlign="haRight" ParentFont="False" Text="[SUM(&#60;SQL Mestre.&#34;VALOR_ISS&#34;&#62;,MasterData1,2)]"/>
      <TfrxSysMemoView Name="SysMemo13" AllowVectorExport="True" Left="678,09448819" Top="4" Width="72,44094" Height="12" DisplayFormat.DecimalSeparator="," DisplayFormat.FormatStr="###,###,##0.00" DisplayFormat.Kind="fkNumeric" Font.Charset="1" Font.Color="0" Font.Height="-11" Font.Name="Arial" Font.Style="1" Frame.Typ="4" HAlign="haRight" ParentFont="False" Text="[SUM(&#60;SQL Mestre.&#34;BASE_ICMS&#34;&#62;,MasterData1,2)]"/>
      <TfrxSysMemoView Name="SysMemo14" AllowVectorExport="True" Left="752,11023622" Top="4" Width="72,44094" Height="12" DisplayFormat.DecimalSeparator="," DisplayFormat.FormatStr="###,###,##0.00" DisplayFormat.Kind="fkNumeric" Font.Charset="1" Font.Color="0" Font.Height="-11" Font.Name="Arial" Font.Style="1" Frame.Typ="4" HAlign="haRight" ParentFont="False" Text="[SUM(&#60;SQL Mestre.&#34;VALOR_ICMS&#34;&#62;,MasterData1,2)]"/>
      <TfrxSysMemoView Name="SysMemo15" AllowVectorExport="True" Left="826,12598425" Top="4" Width="72,44094" Height="12" DisplayFormat.DecimalSeparator="," DisplayFormat.FormatStr="###,###,##0.00" DisplayFormat.Kind="fkNumeric" Font.Charset="1" Font.Color="0" Font.Height="-11" Font.Name="Arial" Font.Style="1" Frame.Typ="4" HAlign="haRight" ParentFont="False" Text="[SUM(&#60;SQL Mestre.&#34;BASE_IPI&#34;&#62;,MasterData1,2)]"/>
      <TfrxSysMemoView Name="SysMemo16" AllowVectorExport="True" Left="900,14173228" Top="4" Width="72,56692425" Height="12" DisplayFormat.DecimalSeparator="," DisplayFormat.FormatStr="###,###,##0.00" DisplayFormat.Kind="fkNumeric" Font.Charset="1" Font.Color="0" Font.Height="-11" Font.Name="Arial" Font.Style="1" Frame.Typ="4" HAlign="haRight" ParentFont="False" Text="[SUM(&#60;SQL Mestre.&#34;VALOR_IPI&#34;&#62;,MasterData1,2)]"/>
      <TfrxSysMemoView Name="SysMemo17" AllowVectorExport="True" Left="973,77952756" Top="4" Width="72,56692425" Height="12" DisplayFormat.DecimalSeparator="," DisplayFormat.FormatStr="###,###,##0.00" DisplayFormat.Kind="fkNumeric" Font.Charset="1" Font.Color="0" Font.Height="-11" Font.Name="Arial" Font.Style="1" Frame.Typ="4" HAlign="haRight" ParentFont="False" Text="[SUM(&#60;SQL Mestre.&#34;VALOR_TOTAL_NOTA&#34;&#62;,MasterData1,2)]"/>
      <TfrxMemoView Name="Memo13" AllowVectorExport="True" Left="75,81107" Top="4" Width="308" Height="12" Font.Charset="1" Font.Color="0" Font.Height="-11" Font.Name="Arial" Font.Style="1" Frame.Typ="0" HAlign="haRight" ParentFont="False" Text="TOTAL GERAL ACUMULADO"/>
    </TfrxReportSummary>
  </TfrxReportPage>
</TfrxReport>
