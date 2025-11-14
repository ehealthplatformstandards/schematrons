<?xml version="1.0" encoding="UTF-8"?>
<!-- 
Property : eHealth
Author   : eh068
Date     : 2025-03-18
-->
<iso:schema 	xmlns="http://purl.oclc.org/dsdl/schematron"
						xmlns:iso="http://purl.oclc.org/dsdl/schematron"
						xmlns:sch="http://www.ascc.net/xml/schematron"
						xmlns:kmehr="http://www.ehealth.fgov.be/standards/kmehr/schema/v1"
						queryBinding="xslt2"
						schemaVersion="ISO19757-3" defaultPhase='#ALL'
						>
	
		<iso:title>Checking an incapacity document</iso:title>
		<iso:ns prefix="kmehr" uri="http://www.ehealth.fgov.be/standards/kmehr/schema/v1" />

<!-- CD & ID ERRORS -->
<iso:pattern id="id-kmehr.structure.checks">
	<iso:title>Kmehr id-kmehr structure checks for key elements</iso:title>
	<iso:rule context="*[local-name()='header' or local-name()='folder' or local-name()='transaction' or local-name()='heading' or local-name()='item']">
			<iso:assert test="count( kmehr:id[@S = 'ID-KMEHR'] ) &lt; 2" id="Identification" role="ERROR" flag="structure"  >
			"<iso:value-of select="local-name()"/>" element can be identified by maximum one 'official' id element (ID-KMEHR).
			</iso:assert>
	</iso:rule>
</iso:pattern>

<iso:pattern id="inss.structure.checks">
	<iso:title>Kmehr inss structure checks</iso:title>
	<iso:rule context="//*[kmehr:id[@S = 'ID-PATIENT' or @S = 'INSS']]">
			<iso:assert test="count(kmehr:id[@S = 'ID-PATIENT' or @S = 'INSS']) &lt; 2" id="Identification" role="ERROR" flag="structure" >
			"<iso:value-of select="local-name()"/>" element must have maximum one INSS code. (Number: <iso:value-of select="count(kmehr:id[@S='ID-PATIENT' or @S = 'INSS'])"/>)
			</iso:assert>
	</iso:rule>
</iso:pattern>

<iso:pattern id="inss.values.checks">
	<iso:title>Kmehr inss values checks</iso:title>
	<iso:rule context="kmehr:id[ @S = 'ID-PATIENT' or @S = 'INSS']">
			<iso:assert test="number(current()) = floor(number(current())) and number(current()) &lt; 100000000000 and ((97 - (floor(number(current()) div 100) mod 97) = (number(current()) mod 100)) or (97 - ((2000000000 + floor(number(current()) div 100)) mod 97) = (number(current()) mod 100)))" id="Identification" role="ERROR" flag="value" >
			INSS number must be correct - INSS: <iso:value-of select="."/>
			</iso:assert>
	</iso:rule>	
</iso:pattern>

<iso:pattern id="id-hcparty.structure.checks">
	<iso:title>Kmehr id-hcparty structure checks</iso:title>
	<iso:rule context="//*[kmehr:id[@S = 'ID-HCPARTY']]">
			<iso:assert test="count(kmehr:id[@S = 'ID-HCPARTY']) &lt; 2" id="Identification" role="ERROR" flag="structure" >
			"<iso:value-of select="local-name()"/>" element must have maximum one INAMI/RIZIV code. (Number: <iso:value-of select="count(kmehr:id[@S='ID-HCPARTY'])"/>)
			</iso:assert>
	</iso:rule>
</iso:pattern>

<iso:pattern id="id-hcparty.values.checks">
	<iso:title>Kmehr id-hcparty values checks</iso:title>
	<iso:rule context="kmehr:id[@S = 'ID-HCPARTY']">
			<iso:assert test="string-length(current()) = 0 or number(current()) = floor(number(current())) and ((( string-length(current()) = 8 or string-length(current()) = 10) and ( number(current()) mod 100) = (97 - (floor(number(current()) div 100) mod 97) ) ) or (( string-length(current()) = 8 or string-length(current()) = 10) and ( number(current()) mod 100) = (89 - (floor(number(current()) div 100) mod 89) ) ) or ( string-length(current()) = 11 and ( floor((number(current()) div 1000) ) mod 100) = (97 - (floor(number(current()) div 100000) mod 97) ) ) or ( string-length(current()) = 11 and ( floor((number(current()) div 1000) ) mod 100) = (89 - (floor(number(current()) div 100000) mod 89) ) ))" id="Identification" role="ERROR" flag="value ">
			INAMI/RIZIV number must be correct. (id: <iso:value-of select="."/>)
			</iso:assert>
	</iso:rule>
</iso:pattern>

<!-- ID-KMEHR WARNINGS -->
<iso:pattern id="id-kmehr.structure.warnings.checks">
	<iso:title>Kmehr id-kmehr structure warnings checks for key elements</iso:title>
	<iso:rule context="kmehr:*[local-name()='header' or local-name()='folder' or local-name()='transaction' or local-name()='heading' or local-name()='item']">
			<iso:assert test="kmehr:id[@S='ID-KMEHR']" id="Identification" role="WARNING" flag="structure"  >
			"<iso:value-of select="local-name()"/>" element should be identified by one 'official' id element (ID-KMEHR).
			</iso:assert>
	</iso:rule>
</iso:pattern>

 <iso:pattern id="id-kmehr.values.warnings.checks">
	<iso:title>Kmehr id-kmehr values warnings for key elements</iso:title>
			<iso:rule context="//*[ (local-name()='folder' or local-name()='transaction' or local-name()='heading') and (count(kmehr:id[@S='ID-KMEHR'])=1) ]">
					<iso:assert test="( (count(current()/preceding-sibling::*[not(local-name()='header') and not(local-name()='item') and (count(kmehr:id[@S='ID-KMEHR'])=1)]) = 0 ) and (number(current()/kmehr:id[@S='ID-KMEHR']) = 1 ) ) or ( (number( current()/kmehr:id[@S='ID-KMEHR'] ) - 1) = number(current()/preceding-sibling::*[not(local-name()='header') and not(local-name()='item') and (count(kmehr:id[@S='ID-KMEHR'])=1)][1]/kmehr:id[@S='ID-KMEHR']) )" id="Identification" role="WARNING" >
			Official id (ID-KMEHR) for "<iso:value-of select="local-name()"/>" element must be correct. (ID's start with 1 and are sequential.) Actual id: <iso:value-of select="number(current()/kmehr:id[@S='ID-KMEHR'])"/>. Preceding id: <iso:value-of select="number(current()/preceding-sibling::*[(count(kmehr:id[@S='ID-KMEHR'])=1)][1]/kmehr:id[@S='ID-KMEHR'])"/>. Following id: <iso:value-of select="number(current()/following-sibling::*[(count(kmehr:id[@S='ID-KMEHR'])=1)][1]/kmehr:id[@S='ID-KMEHR'])"/>.
			</iso:assert>
	</iso:rule>
</iso:pattern>

 <iso:pattern id="items-id-kmehr.values.warnings.checks">
	<iso:title>Kmehr id-kmehr values warnings for items</iso:title>
	<iso:rule context="//*[local-name()='item' and (count(kmehr:id[@S='ID-KMEHR'])=1)]">
			<iso:assert test="((count(current()/preceding-sibling::*[not(local-name()='header') and not(local-name()='heading') and (count(kmehr:id[@S='ID-KMEHR'])=1)]) = 0 ) and ( number( current()/kmehr:id[@S='ID-KMEHR'] ) = 1 )) or ((number(current()/kmehr:id[@S='ID-KMEHR']) - 1) = number(current()/preceding-sibling::*[not(local-name()='header') and not(local-name()='heading') and (count(kmehr:id[@S='ID-KMEHR'])=1)][1]/kmehr:id[@S='ID-KMEHR']) )" id="Identification" role="WARNING" >
			Official id (ID-KMEHR) for "<iso:value-of select="local-name()"/>" element must be correct. (ID's start with 1 and are sequential.) Actual id: <iso:value-of select="number( current()/kmehr:id[@S='ID-KMEHR'] )"/>. Preceding id: <iso:value-of select="number(current()/preceding-sibling::*[(count(kmehr:id[@S='ID-KMEHR'])=1)][1]/kmehr:id[@S='ID-KMEHR'])"/>. Following id: <iso:value-of select="number(current()/following-sibling::*[(count(kmehr:id[@S='ID-KMEHR'])=1)][1]/kmehr:id[@S='ID-KMEHR'])"/>.
			</iso:assert>
	</iso:rule>
</iso:pattern>

<!-- FOLDER -->
<iso:pattern id="folder.structure.checks" role="folder">
	<iso:title>Folder structure checks</iso:title>
	<iso:rule context="kmehr:kmehrmessage" >
			<iso:assert test="count(kmehr:folder) = 1" id="Folder" role="ERROR" flag="structure" >
			Incapacity format must have only one folder. (Number: <iso:value-of select="count(kmehr:folder)"/>)
			</iso:assert>
	</iso:rule>
</iso:pattern>

<!-- HEADER -->
<iso:pattern id="header.structure.checks" role="header">
	<iso:title>Header structure checks</iso:title>
	<iso:rule context="kmehr:header/kmehr:recipient/kmehr:hcparty/kmehr:id[@S='ID-CBE' and .='0869909460' or .='0308357555']" >
			<iso:assert test="not(//kmehr:transaction[kmehr:cd[@S='CD-TRANSACTION' and .='notification']]//kmehr:item[kmehr:cd[@S='CD-ITEM' and .='incapacity']]/kmehr:content[kmehr:incapacity/kmehr:incapacityreason/kmehr:cd[@S='CD-INCAPACITYREASON' and .='pregnancy']])" id="Header" role="ERROR" flag="structure" >
			Pregnancy incapacity reason can't be present if the recipient id is "0869909460" or "0308357555".
			</iso:assert>
			<iso:assert test="not(//kmehr:transaction[kmehr:cd[@S='CD-TRANSACTION' and .='notification']]//kmehr:item/kmehr:cd[@S='LOCAL' and @SL='MMEDIATT-ITEM' and .='expectedbirthgivingdate'])" id="Header" role="ERROR" flag="structure" >
			Expected birth giving date can't be present if the recipient id is "0869909460" or "0308357555".
			</iso:assert>
			<iso:assert test="not(//kmehr:transaction[kmehr:cd[@S='CD-TRANSACTION' and .='notification']]//kmehr:item/kmehr:cd[@S='LOCAL' and @SL='MMEDIATT-ITEM' and .='maternityleave'])" id="Header" role="ERROR" flag="structure" >
			Maternity leave can't be present if the recipient id is "0869909460" or "0308357555".
			</iso:assert>
	</iso:rule> 
	<iso:rule context="kmehr:header[//kmehr:transaction/kmehr:item[kmehr:cd[@S='CD-ITEM' and .='incapacity']]/kmehr:content[kmehr:incapacity/kmehr:incapacityreason/kmehr:cd[@S='CD-INCAPACITYREASON' and .='pregnancy']] and //kmehr:patient/kmehr:profession/kmehr:cd[@S='CD-EMPLOYMENTSITUATION' and .='selfemployed']]/kmehr:recipient/kmehr:hcparty/kmehr:id[@S='ID-CBE' and .='0820563481']" >
			<iso:assert test="count(//kmehr:transaction/kmehr:item/kmehr:cd[@S='LOCAL' and @SL='MMEDIATT-ITEM' and .='expectedbirthgivingdate']) &gt; 0" id="Expected birth giving date" role="ERROR" flag="structure"  >
			Expected birth giving date must be present for a female self-employed pregnancy. (Number: <iso:value-of select="count(//kmehr:transaction/kmehr:item/kmehr:cd[@S='LOCAL' and @SL='MMEDIATT-ITEM' and .='expectedbirthgivingdate'])"/>)
			</iso:assert>
			<iso:assert test="count(//kmehr:transaction/kmehr:item/kmehr:cd[@S='LOCAL' and @SL='MMEDIATT-ITEM' and .='maternityleave']) &gt; 0" id="Maternity leave" role="ERROR" flag="structure"  >
			Maternity leave must be present for a female self-employed pregnancy. (Number: <iso:value-of select="count(//kmehr:transaction/kmehr:item/kmehr:cd[@S='CD-ITEM' and .='maternityleave'])"/>)
			</iso:assert>
	</iso:rule>
</iso:pattern>

<!-- PATIENT -->
<iso:pattern id="patient.structure.checks" role="patient">
	<iso:title>Patient structure checks</iso:title>
	<iso:rule context="kmehr:patient" >
			<iso:assert test="kmehr:usuallanguage" id="Patient" role="ERROR" flag="structure" >
			Patient must have a usual language.
			</iso:assert>
	</iso:rule>
	<iso:rule context="kmehr:patient/kmehr:address">
			<iso:assert test="kmehr:cd[@S = 'CD-ADDRESS' and .='careaddress']" id="Patient" role="ERROR" flag="structure"  >
			Value from CD-ADDRESS must be 'careaddress'. (Value: <iso:value-of select="kmehr:cd[@S = 'CD-ADDRESS']"/>)
			</iso:assert>
			<iso:assert test="not(//kmehr:transaction/kmehr:cd[@S='CD-TRANSACTION-INC-NOT' and .='c'])" id="Patient" role="ERROR" flag="structure"  >
			Dataset 'c' can't have care address. (dataset: <iso:value-of select="//kmehr:transaction/kmehr:cd[@S='CD-TRANSACTION-INC-NOT']"/>)
			</iso:assert>
	</iso:rule>
	<iso:rule context="kmehr:patient/kmehr:telecom">
			<iso:assert test="not(//kmehr:transaction/kmehr:cd[@S='CD-TRANSACTION-INC-NOT' and .='c'])" id="Patient" role="ERROR" flag="structure"  >
			Dataset 'c' can't have telecom. (dataset: <iso:value-of select="//kmehr:transaction/kmehr:cd[@S='CD-TRANSACTION-INC-NOT']"/>)
			</iso:assert>
	</iso:rule>	
	<iso:rule context="kmehr:patient/kmehr:profession">
			<iso:assert test="not(//kmehr:transaction/kmehr:cd[@S='CD-TRANSACTION-INC-NOT' and .='c'])" id="Patient" role="ERROR" flag="structure"  >
			Dataset 'c' can't have profession. (dataset: <iso:value-of select="//kmehr:transaction/kmehr:cd[@S='CD-TRANSACTION-INC-NOT']"/>)
			</iso:assert>
	</iso:rule>	
</iso:pattern>

<!-- TRANSACTION -->
<iso:pattern id="transaction.structure.checks" role="transaction">
	<iso:title>Transaction structure checks</iso:title>
	<iso:rule context="kmehr:transaction" >
			<iso:assert test="kmehr:cd[@S='CD-TRANSACTION-INC-NOT']" id="Transaction" role="ERROR" flag="structure" >
			Transaction must contain a dataset value. (Actual: <iso:value-of select="."/>)
			</iso:assert>
			<iso:assert test="kmehr:cd[@S='CD-TRANSACTION-TYPE' and .='incapacity' or .='incapacityextension' or .='incapacityrelapse' or .='adanormal' or .='adaextension' or .='adarelapse']" id="Transaction" role="ERROR" flag="structure" >
			Transaction type must be one of these: "incapacity", "incapacityextension", "incapacityrelapse", "adanormal", "adaextension", "adarelapse". (Actual: <iso:value-of select="kmehr:cd[@S='CD-TRANSACTION-TYPE']"/>)
			</iso:assert>
	</iso:rule>
	<iso:rule context="kmehr:transaction/kmehr:cd[@S='CD-TRANSACTION-INC-NOT']" >
			<iso:assert test="current() = 'a' or current() = 'b' or current() = 'c'" id="Transaction" role="ERROR" flag="structure" >
			Dataset value must be "a", "b" or "c". (Actual: <iso:value-of select="."/>)
			</iso:assert>
	</iso:rule>
	<iso:rule context="kmehr:transaction/kmehr:cd[@S='CD-TRANSACTION']" >
			<iso:assert test="current() = 'notification'" id="Transaction" role="ERROR" flag="structure" >
			Transaction must be : "notification". (Actual: <iso:value-of select="."/>)
			</iso:assert>
	</iso:rule>
</iso:pattern>

<!-- DATES -->
<iso:pattern id="date.structure.checks" role="transaction">
	<iso:title>Date structure checks</iso:title>
	<iso:rule context="kmehr:endmoment" >
			<iso:assert test=". ge ../kmehr:beginmoment" id="Dates" role="ERROR" flag="structure"  >
			Beginmoment must be before endmoment.
			</iso:assert>
	</iso:rule>
</iso:pattern>

<!-- DATASET C SPECIFIC RULES -->
<iso:pattern id="datasetc.structure.checks" role="author">
	<iso:title>DATASET C structure checks</iso:title>
	<iso:rule context="//kmehr:transaction[kmehr:cd[@S='CD-TRANSACTION-INC-NOT' and .='c']]" >
			<iso:assert test="not(kmehr:author/kmehr:hcparty/kmehr:id[@S='INSS'])" id="Author" role="ERROR" flag="structure"  >
			Author can't have an INSS when dataset is "c"._||__||__||_
			</iso:assert>
	</iso:rule>
</iso:pattern>


<!-- ITEMS -->
<iso:pattern id="clinicalsummary.structure.checks">
	<iso:title>Items structure checks</iso:title>
	<iso:rule context="kmehr:item">
			<iso:assert test="count(kmehr:cd[@S = 'CD-ITEM']) + count(kmehr:cd[@S = 'CD-INVOLVED-PARTY']) + count(kmehr:cd[@S='LOCAL' and @SL='MMEDIATT-ITEM' and not(.='principal')]) = 1" id="Item" role="ERROR" flag="structure"  >
			All items must be codified by one code CD-ITEM, CD-INVOLVED-PARTY  or local 'MMEDIATT-ITEM' and only one. (Number: <iso:value-of select="count(kmehr:cd[@S='CD-ITEM']) + count(kmehr:cd[@S = 'CD-INVOLVED-PARTY']) + count(kmehr:cd[@S='LOCAL' and @SL='MMEDIATT-ITEM'])"/>)
			</iso:assert>
	</iso:rule>
	<iso:rule context="kmehr:transaction[kmehr:cd[@S='CD-TRANSACTION' and .='notification']]//kmehr:item/kmehr:cd[@S = 'CD-ITEM']">
			<iso:assert test="	 
						(current()='contactperson') or 
						(current()='diagnosis') or 
						(current()='dischargedatetime') or 
						(current()='encounterdatetime') or
						(current()='encounterlocation') or  
						(current()='encountertype') or 
						(current()='incapacity') " 
					id="Item" role="ERROR" flag="structure"  >
			Item code must be one of these: "contactperson", "diagnosis", "dischargedatetime", "encounterdatetime", "encounterlocation", "encountertype" or "incapacity". (CD-ITEM: "<iso:value-of select="current()"/>")
			</iso:assert>
	</iso:rule>
	<iso:rule context="kmehr:transaction[kmehr:cd[@S='CD-TRANSACTION' and .='notification']]//kmehr:item/kmehr:cd[@S='LOCAL' and @SL='MMEDIATT-ITEM']">
			<iso:assert test="	 
						(current()='expectedbirthgivingdate') or 
						(current()='maternityleave') or 
						(current()='foreignstay') or 
						(current()='principal') " 
					id="Item" role="ERROR" flag="structure"  >
			Item local code must be one of these: "expectedbirthgivingdate", "maternityleave", "foreignstay" or "principal". (Value: "<iso:value-of select="current()"/>")
			</iso:assert>
	</iso:rule>
	<iso:rule context="kmehr:transaction[kmehr:cd[@S='CD-TRANSACTION' and .='notification']]">
			<iso:assert test="count(kmehr:item[kmehr:cd[@S='CD-ITEM' and .='incapacity']]) = 1" id="Incapacity" role="ERROR" flag="structure"  >
			Incapacity notification must contain one and only one incapacity item. (Number: <iso:value-of select="count(//kmehr:item[kmehr:cd[@S='CD-ITEM' and .='incapacity']])"/>)
			</iso:assert>
			<iso:assert test="count(kmehr:item[kmehr:cd[@S='CD-ITEM' and .='diagnosis']]) &lt; 4" id="Diagnosis" role="ERROR" flag="structure"  >
			There can be maximum three diagnosis. (Number: <iso:value-of select="count(//kmehr:item[kmehr:cd[@S='CD-ITEM' and .='diagnosis']])"/>)
			</iso:assert>
			<iso:assert test="not(../kmehr:transaction[kmehr:cd[@S='CD-TRANSACTION-INC-NOT' and .='a']] and count(kmehr:item[kmehr:cd[@S='CD-ITEM' and .='diagnosis']]) = 0)" id="Diagnosis" role="ERROR" flag="structure"  >
			Dataset 'a' must contain a diagnosis. (Number: <iso:value-of select="count(//kmehr:item[kmehr:cd[@S='CD-ITEM' and .='diagnosis']])"/>)
			</iso:assert>
			<iso:assert test="not(../kmehr:transaction[kmehr:cd[@S='CD-TRANSACTION-INC-NOT' and .='c']] and count(kmehr:item[kmehr:cd[@S='CD-ITEM' and .='diagnosis']]) &gt; 0)" id="Diagnosis" role="ERROR" flag="structure"  >
			Dataset 'c' can't contain a diagnosis. (Number: <iso:value-of select="count(//kmehr:item[kmehr:cd[@S='CD-ITEM' and .='diagnosis']])"/>)
			</iso:assert>
			<iso:assert test="count(kmehr:item[kmehr:cd[@S='CD-ITEM' and .='encountertype']]) &lt; 2" id="Encounter type" role="ERROR" flag="structure"  >
			There can be maximum one encounter type. (Number: <iso:value-of select="count(//kmehr:item[kmehr:cd[@S='CD-ITEM' and .='encountertype']])"/>)
			</iso:assert>
			<iso:assert test="not(../kmehr:transaction[kmehr:cd[@S='CD-TRANSACTION-INC-NOT' and .='c']] and count(kmehr:item[kmehr:cd[@S='CD-ITEM' and .='encountertype']]) &gt; 0)" id="Encounter type" role="ERROR" flag="structure"  >
			Dataset 'c' can't contain encounter type. (Number: <iso:value-of select="count(//kmehr:item[kmehr:cd[@S='CD-ITEM' and .='encountertype']])"/>)
			</iso:assert>
			<iso:assert test="count(kmehr:item[kmehr:cd[@S='CD-ITEM' and .='encounterdatetime']]) &lt; 2" id="Encounter datetime" role="ERROR" flag="structure"  >
			There can be maximum one encounter datetime. (Number: <iso:value-of select="count(//kmehr:item[kmehr:cd[@S='CD-ITEM' and .='encounterdatetime']])"/>)
			</iso:assert>
			<iso:assert test="not(../kmehr:transaction[kmehr:cd[@S='CD-TRANSACTION-INC-NOT' and .='c']] and count(kmehr:item[kmehr:cd[@S='CD-ITEM' and .='encounterdatetime']]) &gt; 0)" id="Encounter datetime" role="ERROR" flag="structure"  >
			Dataset 'c' can't contain encounter datetime. (Number: <iso:value-of select="count(//kmehr:item[kmehr:cd[@S='CD-ITEM' and .='encounterdatetime']])"/>)
			</iso:assert>
			<iso:assert test="count(kmehr:item[kmehr:cd[@S='CD-ITEM' and .='dischargedatetime']]) &lt; 2" id="Discharge datetime" role="ERROR" flag="structure"  >
			There can be maximum one discharge datetime. (Number: <iso:value-of select="count(//kmehr:item[kmehr:cd[@S='CD-ITEM' and .='dischargedatetime']])"/>)
			</iso:assert>
			<iso:assert test="not(../kmehr:transaction[kmehr:cd[@S='CD-TRANSACTION-INC-NOT' and .='c']] and count(kmehr:item[kmehr:cd[@S='CD-ITEM' and .='dischargedatetime']]) &gt; 0)" id="Discharge datetime" role="ERROR" flag="structure"  >
			Dataset 'c' can't contain discharge datetime. (Number: <iso:value-of select="count(//kmehr:item[kmehr:cd[@S='CD-ITEM' and .='dischargedatetime']])"/>)
			</iso:assert>
			<iso:assert test="count(kmehr:item[kmehr:cd[@S='CD-ITEM' and .='encounterlocation']]) &lt; 2" id="Encounter location" role="ERROR" flag="structure"  >
			There can be maximum one encounter location. (Number: <iso:value-of select="count(//kmehr:item[kmehr:cd[@S='CD-ITEM' and .='encounterlocation']])"/>)
			</iso:assert>
			<iso:assert test="not(../kmehr:transaction[kmehr:cd[@S='CD-TRANSACTION-INC-NOT' and .='c']] and count(kmehr:item[kmehr:cd[@S='CD-ITEM' and .='encounterlocation']]) &gt; 0)" id="Encounter location" role="ERROR" flag="structure"  >
			Dataset 'c' can't contain encounter location. (Number: <iso:value-of select="count(//kmehr:item[kmehr:cd[@S='CD-ITEM' and .='encounterlocation']])"/>)
			</iso:assert>
			<iso:assert test="count(kmehr:item[kmehr:cd[@S='LOCAL' and @SL='MMEDIATT-ITEM' and .='expectedbirthgivingdate']]) &lt; 2" id="Expected birth giving date" role="ERROR" flag="structure"  >
			There can be maximum one expected birth giving date. (Number: <iso:value-of select="count(//kmehr:item[kmehr:cd[@S='LOCAL' and @SL='MMEDIATT-ITEM' and .='expectedbirthgivingdate']])"/>)
			</iso:assert>
			<iso:assert test="count(kmehr:item[kmehr:cd[@S='LOCAL' and @SL='MMEDIATT-ITEM' and .='maternityleave']]) &lt; 2" id="Maternity leave" role="ERROR" flag="structure"  >
			There can be maximum one maternity leave. (Number: <iso:value-of select="count(//kmehr:item[kmehr:cd[@S='LOCAL' and @SL='MMEDIATT-ITEM' and .='maternityleave']])"/>)
			</iso:assert>
			<iso:assert test="count(kmehr:item[kmehr:cd[@S='LOCAL' and @SL='MMEDIATT-ITEM' and .='foreignstay']]) &lt; 2" id="Foreign stay" role="ERROR" flag="structure"  >
			There can be maximum one foreign stay. (Number: <iso:value-of select="count(//kmehr:item[kmehr:cd[@S='CD-ITEM' and .='foreignstay']])"/>)
			</iso:assert>
			<iso:assert test="not(../kmehr:transaction[kmehr:cd[@S='CD-TRANSACTION-INC-NOT' and .='c' or .='a']] and count(kmehr:item[kmehr:cd[@S='LOCAL' and @SL='MMEDIATT-ITEM'  and .='foreignstay']]) &gt; 0)" id="Foreign stay" role="ERROR" flag="structure"  >
			Dataset 'a' and 'c' can't have foreign stay. (dataset: <iso:value-of select="//kmehr:transaction/kmehr:cd[@S='CD-TRANSACTION-INC-NOT']"/>)
			</iso:assert>
	</iso:rule>
</iso:pattern>

<!-- INCAPACITY -->
<iso:pattern id="incapacity.structure.checks">
	<iso:title>Incapacity structure checks</iso:title>
	<iso:rule context="kmehr:transaction[kmehr:cd[@S='CD-TRANSACTION' and .='notification']]//kmehr:item[kmehr:cd[@S='CD-ITEM' and .='incapacity']]">
			<iso:assert test="count(kmehr:content[kmehr:incapacity[kmehr:cd[@S='CD-INCAPACITY']]]) = 1" id="Incapacity" role="ERROR" flag="structure"  >
			Incapacity item must contain one (and only one) incapacity content with codified incapacity. (Number: <iso:value-of select="count(kmehr:content[kmehr:incapacity[kmehr:cd[@S='CD-INCAPACITY']]])"/>)
			</iso:assert>
			<iso:assert test="count(kmehr:content[kmehr:incapacity[kmehr:incapacityreason[kmehr:cd[@S='CD-INCAPACITYREASON']]]]) = 1" id="Incapacity" role="ERROR" flag="structure"  >
			Incapacity item must contain one (and only one) incapacity content with codified incapacityreason. (Number: <iso:value-of select="count(kmehr:content[kmehr:incapacity[kmehr:incapacityreason[kmehr:cd[@S='CD-INCAPACITYREASON']]]])"/>)
			</iso:assert>
			<iso:assert test="count(kmehr:content[kmehr:incapacity[kmehr:outofhomeallowed]]) = 1" id="Incapacity" role="ERROR" flag="structure"  >
			Incapacity item must contain one (and only one) incapacity content with "outofhomeallowed" boolean value. (Number: <iso:value-of select="count(kmehr:content[kmehr:incapacity[kmehr:outofhomeallowed]])"/>)
			</iso:assert>
			<iso:assert test="kmehr:content/kmehr:incapacity/kmehr:percentage" id="Incapacity" role="ERROR" flag="structure"  >
			Incapacity item must have a "percentage".
			</iso:assert>
			<iso:assert test="kmehr:beginmoment" id="Incapacity" role="ERROR" flag="structure"  >
			Incapacity item must have a "beginmoment".
			</iso:assert>
			<iso:assert test="kmehr:endmoment" id="Incapacity" role="ERROR" flag="structure"  >
			Incapacity item must have a "endmoment".
			</iso:assert>
	</iso:rule>
	<iso:rule context="kmehr:transaction[kmehr:cd[@S='CD-TRANSACTION' and .='notification']]//kmehr:item[kmehr:cd[@S='CD-ITEM' and .='incapacity']]/kmehr:content/kmehr:incapacity">
			<iso:assert test="count(kmehr:cd) = 1" id="Incapacity" role="ERROR" flag="structure"  >
			Incapacity content must contain one (and only one) cd element. (Number: <iso:value-of select="count(kmehr:cd)"/>)
			</iso:assert>
	</iso:rule>
	<iso:rule context="kmehr:transaction[kmehr:cd[@S='CD-TRANSACTION' and .='notification']]//kmehr:item[kmehr:cd[@S='CD-ITEM' and .='incapacity']]/kmehr:content/kmehr:incapacity/kmehr:incapacityreason">
			<iso:assert test="kmehr:cd[@S='CD-INCAPACITYREASON' and .='illness' or .='accident' or .='traveltofromworkaccident' or .='workaccident' or .='occupationaldisease' or .='pregnancy']" id="Incapacity" role="ERROR" flag="structure"  >
			Incapacity reason values must be one of these "illness" or "accident" or "traveltofromworkaccident" or "workaccident" or "occupationaldisease" or "pregnancy". (Value: <iso:value-of select="kmehr:cd[@S='CD-INCAPACITYREASON']"/>)
			</iso:assert>
	</iso:rule>
	<iso:rule context="kmehr:transaction[kmehr:cd[@S='CD-TRANSACTION' and .='notification']]//kmehr:item[kmehr:cd[@S='CD-ITEM' and .='incapacity']]/kmehr:content[kmehr:incapacity/kmehr:incapacityreason/kmehr:cd[@S='CD-INCAPACITYREASON' and .='accident' or .='traveltofromworkaccident']]">
			<iso:assert test="../count(kmehr:content[kmehr:date]) = 1" id="Incapacity" role="ERROR" flag="structure"  >
			Incapacity item must contain one (and only one) date content if incapacity reason is "accident" or "traveltofromworkaccident". (Number: <iso:value-of select="../count(kmehr:content[kmehr:date])"/>)
			</iso:assert>
	</iso:rule>
	<iso:rule context="kmehr:transaction[kmehr:cd[@S='CD-TRANSACTION' and .='notification']]//kmehr:item[kmehr:cd[@S='CD-ITEM' and .='incapacity']]/kmehr:content[kmehr:incapacity/kmehr:incapacityreason/kmehr:cd[@S='CD-INCAPACITYREASON' and .='workaccident' or .='occupationaldisease']]">
			<iso:assert test="../count(kmehr:content[kmehr:date]) = 1" id="Incapacity" role="ERROR" flag="structure"  >
			Incapacity item must contain one (and only one) date content if incapacity reason is "workaccident" or "occupationaldisease". (Number: <iso:value-of select="../count(kmehr:content[kmehr:date])"/>)
			</iso:assert>
	</iso:rule>
	<iso:rule context="kmehr:transaction[kmehr:cd[@S='CD-TRANSACTION' and .='notification']]//kmehr:item[kmehr:cd[@S='CD-ITEM' and .='incapacity']]/kmehr:content[kmehr:incapacity/kmehr:incapacityreason/kmehr:cd[@S='CD-INCAPACITYREASON' and .='pregnancy']]">
			<iso:assert test="not(//kmehr:transaction/kmehr:cd[@S='CD-TRANSACTION-INC-NOT' and .='c'])" id="Incapacity reason" role="ERROR" flag="structure"  >
			Dataset 'c' can't have pregnancy incapacity reason. (dataset: <iso:value-of select="//kmehr:transaction/kmehr:cd[@S='CD-TRANSACTION-INC-NOT']"/>)
			</iso:assert>
	</iso:rule>
</iso:pattern>

<!-- DIAGNOSIS -->
<iso:pattern id="diagnosis.structure.checks">
	<iso:title>Diagnosis structure checks</iso:title>
	<iso:rule context="kmehr:transaction[kmehr:cd[@S='CD-TRANSACTION' and .='notification']]/kmehr:item[kmehr:cd[@S='CD-ITEM' and .='diagnosis']]">
			<iso:assert test="count(kmehr:content[kmehr:cd]) + count(kmehr:content[kmehr:text]) &gt; 0" id="Diagnosis" role="ERROR" flag="structure"  >
			Diagnosis item must contain at least one (and only one) cd or text content. (Number: <iso:value-of select="count(kmehr:content[kmehr:cd])"/>)
			</iso:assert>
			<iso:assert test="count(kmehr:content/kmehr:cd[@S='ICD']) &lt;= 1" id="Diagnosis" role="ERROR" flag="structure">
			Diagnosis can only contain one ICD code.
			</iso:assert>
			<iso:assert test="count(kmehr:content/kmehr:cd[@S='ICPC']) &lt;= 1" id="Diagnosis" role="ERROR" flag="structure">
			Diagnosis can only contain one ICPC code.
			</iso:assert>
			<iso:assert test="kmehr:content/kmehr:cd[@S = 'CD-SNOMED']" id="Diagnosis" role="WARNING" flag="structure"  >
			CD-SNOMED should be used for codified content.
			</iso:assert>
	</iso:rule>
	<iso:rule context="kmehr:transaction[kmehr:cd[@S='CD-TRANSACTION' and .='notification']]//kmehr:item[kmehr:cd[@S='CD-ITEM' and .='diagnosis']]/kmehr:content/kmehr:cd">
			<iso:assert test="@S='ICD' or @S='ICPC' or @S='CD-SNOMED'" id="Diagnosis" role="ERROR" flag="structure"  >
			Diagnosis coded content can only use ICD or ICPC or CD-SNOMED. (Value: <iso:value-of select="@S"/>)
			</iso:assert>
	</iso:rule>
</iso:pattern>

<!-- PRINCIPAL DIAGNOSIS-->
<iso:pattern id="principal.structure.checks">
	<iso:title>Principal diagnosis structure checks</iso:title>
	<iso:rule context="kmehr:transaction[kmehr:cd[@S='CD-TRANSACTION' and .='notification']]/kmehr:item[kmehr:cd[@S='CD-ITEM' and .='diagnosis'] and following-sibling::kmehr:item[kmehr:cd[@S='CD-ITEM' and .='diagnosis']] and not(preceding-sibling::kmehr:item[kmehr:cd[@S='CD-ITEM' and .='diagnosis']])]">
			<iso:assert test="count(../kmehr:item[kmehr:cd[@S='CD-ITEM' and .='diagnosis']]/kmehr:cd[@S = 'LOCAL' and @SL = 'MMEDIATT-ITEM' and .= 'principal']) = 1" id="Principal diagnosis" role="ERROR" flag="structure"  >
			If there is more than one diagnosis item, one must contain one (and only one) local cd with 'principal' value. (Number: <iso:value-of select="count(../kmehr:item[kmehr:cd[@S='CD-ITEM' and .='diagnosis']]/kmehr:cd[@S = 'LOCAL' and @SL = 'MMEDIATT-ITEM' and .= 'principal'])"/>)
			</iso:assert>
	</iso:rule>
</iso:pattern>

<!-- CONTACTPERSON -->
<iso:pattern id="contactperson.structure.checks">
	<iso:title>Contact Person structure checks</iso:title>
	<iso:rule context="kmehr:transaction[kmehr:cd[@S='CD-TRANSACTION' and .='notification']]//kmehr:item[kmehr:cd[@S='CD-ITEM' and .='contactperson']]">
			<iso:assert test="count(kmehr:content/kmehr:person) &gt; 0" id="Contact Person" role="ERROR" flag="structure"  >
			Contact Person must have at least one content person. (Number: <iso:value-of select="count(kmehr:content/kmehr:person)"/>)
			</iso:assert>
	</iso:rule>
	<iso:rule context="kmehr:transaction[kmehr:cd[@S='CD-TRANSACTION' and .='notification']]//kmehr:item[kmehr:cd[@S = 'CD-ITEM' and .='contactperson']]/kmehr:content/*">
			<iso:assert test="local-name()='person'" id="Contact Person" role="ERROR" flag="structure"  >
			A "Contact Person" content can contain only element "person". (Element: "<iso:value-of select="local-name()"/>")
			</iso:assert>
	</iso:rule>
	<iso:rule context="kmehr:transaction[kmehr:cd[@S='CD-TRANSACTION' and .='notification']]//kmehr:item[kmehr:cd[@S='CD-ITEM' and .='contactperson']]/kmehr:content/kmehr:person/kmehr:telecom">
			<iso:assert test="not(//kmehr:transaction/kmehr:cd[@S='CD-TRANSACTION-INC-NOT' and .='c'])" id="Foreign stay" role="ERROR" flag="structure"  >
			Dataset 'c' can't have a telecom in contactperson. (dataset: <iso:value-of select="//kmehr:transaction/kmehr:cd[@S='CD-TRANSACTION-INC-NOT']"/>)
			</iso:assert>
	</iso:rule>
</iso:pattern>

<!-- ENCOUNTERTYPE -->
<iso:pattern id="encountertype.structure.checks">
	<iso:title>Encounter type structure checks</iso:title>
	<iso:rule context="kmehr:transaction[kmehr:cd[@S='CD-TRANSACTION' and .='notification']]//kmehr:item[kmehr:cd[@S='CD-ITEM' and .='encountertype']]">
			<iso:assert test="count(kmehr:content[kmehr:cd[@S='CD-ENCOUNTER']]) = 1" id="Encounter type" role="ERROR" flag="structure"  >
			Encounter type must contain one (and only one) cd content with codified encounter. (Number: <iso:value-of select="count(kmehr:content[kmehr:cd])"/>)
			</iso:assert>
	</iso:rule>
	<iso:rule context="kmehr:transaction[kmehr:cd[@S='CD-TRANSACTION' and .='notification']]//kmehr:item[kmehr:cd[@S='CD-ITEM' and .='encountertype']]/kmehr:content">
			<iso:assert test="count(kmehr:cd) = 1" id="Encounter type" role="ERROR" flag="structure"  >
			Encounter type content must contain one (and only one) cd element. (Number: <iso:value-of select="count(kmehr:cd)"/>)
			</iso:assert>
	</iso:rule>
	<iso:rule context="kmehr:transaction[kmehr:cd[@S='CD-TRANSACTION' and .='notification']]//kmehr:item[kmehr:cd[@S='CD-ITEM' and .='encountertype']]/kmehr:content/kmehr:cd[@S='CD-ENCOUNTER']">
			<iso:assert test="current()='hospital'" id="Encounter type" role="ERROR" flag="structure"  >
			The value of CD-ENCOUNTER must be "hospital". (Value: <iso:value-of select="current()"/>)
			</iso:assert>
	</iso:rule>
</iso:pattern>

<!-- ENCOUNTERDATETIME -->
<iso:pattern id="encounterdatetime.structure.checks">
	<iso:title>Encounterdatetime structure checks</iso:title>
	<iso:rule context="kmehr:transaction[kmehr:cd[@S='CD-TRANSACTION' and .='notification']]/kmehr:item[kmehr:cd[@S='CD-ITEM' and .='encounterdatetime']]">
			<iso:assert test="count(kmehr:content[kmehr:date]) = 1" id="Encounter datetime" role="ERROR" flag="structure"  >
			Encounter datetime must contain one (and only one) date content. (Number: <iso:value-of select="count(kmehr:content[kmehr:date])"/>)
			</iso:assert>
			<iso:assert test="../kmehr:item[kmehr:cd[@S='CD-ITEM' and .='encountertype']]/kmehr:content/kmehr:cd[@S='CD-ENCOUNTER' and .='hospital']" id="Encounter datetime" role="ERROR" flag="structure"  >
			Encounter datetime is allowed only if the value of CD-ENCOUNTER is "hospital". (Value: <iso:value-of select="../kmehr:item[kmehr:cd[@S='CD-ITEM' and .='encountertype']]/kmehr:content/kmehr:cd[@S='CD-ENCOUNTER']"/>)
			</iso:assert>
	</iso:rule>
</iso:pattern>

<!-- DISCHARGEDATETIME -->
<iso:pattern id="dischargedatetime.structure.checks">
	<iso:title>Discharge datetime structure checks</iso:title>
	<iso:rule context="kmehr:transaction[kmehr:cd[@S='CD-TRANSACTION' and .='notification']]/kmehr:item[kmehr:cd[@S='CD-ITEM' and .='dischargedatetime']]">
			<iso:assert test="count(kmehr:content[kmehr:date]) = 1" id="Discharge datetime" role="ERROR" flag="structure"  >
			Discharge datetime must contain one (and only one) datecontent. (Number: <iso:value-of select="count(kmehr:content[kmehr:date])"/>)
			</iso:assert>
			<iso:assert test="../kmehr:item[kmehr:cd[@S='CD-ITEM' and .='encountertype']]/kmehr:content/kmehr:cd[@S='CD-ENCOUNTER' and .='hospital']" id="Discharge datetime" role="ERROR" flag="structure"  >
			Discharge datetime is allowed only if the value of CD-ENCOUNTER is "hospital". (Value: <iso:value-of select="../kmehr:item[kmehr:cd[@S='CD-ITEM' and .='encountertype']]/kmehr:content/kmehr:cd[@S='CD-ENCOUNTER']"/>)
			</iso:assert>
			<iso:assert test="kmehr:content/kmehr:date[1] ge (../kmehr:item[kmehr:cd[@S='CD-ITEM' and .='encounterdatetime']]/kmehr:content/kmehr:date)[1]" id="Discharge datetime" role="ERROR" flag="structure"  >
			Discharge datetime must be bigger or equal to encounter datetime.
			</iso:assert>
	</iso:rule>
</iso:pattern>

<!-- ENCOUNTERLOCATION -->
<iso:pattern id="encounterlocation.structure.checks">
	<iso:title>Encounter location structure checks</iso:title>
	<iso:rule context="kmehr:transaction[kmehr:cd[@S='CD-TRANSACTION' and .='notification']]//kmehr:item[kmehr:cd[@S='CD-ITEM' and .='encounterlocation']]">
			<iso:assert test="count(kmehr:content/kmehr:hcparty) = 1" id="Encounter location" role="ERROR" flag="structure"  >
			Encounter location must have one (and only one) content with "hcparty" element. (Number: <iso:value-of select="count(kmehr:content/kmehr:hcparty)"/>)
			</iso:assert>
			<iso:assert test="../kmehr:item[kmehr:cd[@S='CD-ITEM' and .='encountertype']]/kmehr:content/kmehr:cd[@S='CD-ENCOUNTER' and .='hospital']" id="Encounter location" role="ERROR" flag="structure"  >
			Encounter location is allowed only if the value of CD-ENCOUNTER is "hospital". (Value: <iso:value-of select="../kmehr:item[kmehr:cd[@S='CD-ITEM' and .='encountertype']]/kmehr:content/kmehr:cd[@S='CD-ENCOUNTER']"/>)
			</iso:assert>
	</iso:rule>
	<iso:rule context="kmehr:transaction[kmehr:cd[@S='CD-TRANSACTION' and .='notification']]//kmehr:item[kmehr:cd[@S = 'CD-ITEM' and .='encounterlocation']]/kmehr:content/*">
			<iso:assert test="(local-name()='hcparty')" id="Encounter location" role="ERROR" flag="structure"  >
			A "Contact Hcparty" content can contain only element "hcparty". (Element: "<iso:value-of select="local-name()"/>")
			</iso:assert>
	</iso:rule>
</iso:pattern>

<!-- EXPECTEDBIRTHGIVINGDATE -->
<iso:pattern id="expectedbirthgivingdate.structure.checks">
	<iso:title>Expected birth giving date structure checks</iso:title>
	<iso:rule context="kmehr:transaction[kmehr:cd[@S='CD-TRANSACTION' and .='notification']]//kmehr:item[kmehr:cd[@S='LOCAL' and @SL='MMEDIATT-ITEM' and .='expectedbirthgivingdate']]">
			<iso:assert test="count(kmehr:content[kmehr:date]) = 1" id="Expected birth giving date" role="ERROR" flag="structure"  >
			Expected birth giving date must contain one (and only one) date content. (Number: <iso:value-of select="count(kmehr:content[kmehr:date])"/>)
			</iso:assert>
			<iso:assert test="//kmehr:patient/kmehr:sex/kmehr:cd[@S='CD-SEX' and .='female']" id="Expected birth giving date" role="ERROR" flag="structure"  >
			Expected birth giving is only allowed if the sex of the patient is female. (Value: <iso:value-of select="//kmehr:patient/kmehr:sex/kmehr:cd[@S='CD-SEX']"/>)
			</iso:assert>
	</iso:rule>
</iso:pattern>

<!-- MATERNITYLEAVE -->
<iso:pattern id="maternityleave.structure.checks">
	<iso:title>Maternity leave structure checks</iso:title>
	<iso:rule context="kmehr:transaction[kmehr:cd[@S='CD-TRANSACTION' and .='notification']]//kmehr:item[kmehr:cd[@S='LOCAL' and @SL='MMEDIATT-ITEM' and .='maternityleave']]">
			<iso:assert test="kmehr:beginmoment" id="Maternity leave" role="ERROR" flag="structure"  >
			Maternity leave item must have a "beginmoment".
			</iso:assert>
			<iso:assert test="//kmehr:patient/kmehr:sex/kmehr:cd[@S='CD-SEX' and .='female']" id="Maternity leave" role="ERROR" flag="structure"  >
			Maternity leave is only allowed if the sex of the patient is female.(Value: <iso:value-of select="//kmehr:patient/kmehr:sex/kmehr:cd[@S='CD-SEX']"/>)
			</iso:assert>
	</iso:rule>
</iso:pattern>

<!-- FOREIGNSTAY -->
<iso:pattern id="foreignstay.structure.checks">
	<iso:title>Foreign stay structure checks</iso:title>
	<iso:rule context="kmehr:transaction[kmehr:cd[@S='CD-TRANSACTION' and .='notification']]//kmehr:item[kmehr:cd[@S='LOCAL' and @SL='MMEDIATT-ITEM' and .='foreignstay']]">
			<iso:assert test="kmehr:beginmoment" id="Foreign stay" role="ERROR" flag="structure"  >
			Foreign stay item must have a "beginmoment".
			</iso:assert>
			<iso:assert test="kmehr:endmoment" id="Foreign stay" role="ERROR" flag="structure"  >
			Foreign stay item must have a "endmoment".
			</iso:assert>
	</iso:rule>
</iso:pattern>

</iso:schema>
