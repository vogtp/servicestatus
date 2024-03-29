<%@ page language="java" contentType="text/html; charset=US-ASCII"
	pageEncoding="US-ASCII"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="ch.unibas.spectrum.ssorb.model.ServiceModel"%>
<%@page import="java.util.Map"%>
<%@page import="ch.unibas.spectrum.ssorb.model.Model"%>

<%@page import="java.text.DecimalFormat"%>
<%@page import="ch.unibas.spectrum.ssorb.constants.Attribute"%><html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
<title>Spectrum Services</title>
<link rel="stylesheet" type="text/css"
	href="http://urz.unibas.ch/css/master.css">
<link rel="stylesheet" type="text/css"
	href="http://urz.unibas.ch/css/unibas.css">
<link rel="stylesheet" type="text/css"
	href="http://urz.unibas.ch/css/lightbox.css" />
<link rel="stylesheet" type="text/css"
	href="http://urz.unibas.ch/css/main.css" title="Default Style"
	media="screen" />
</head>
<body style="width: 500px; background-color: #F5F5F3;">
<div id='content'
	style="text-align: left; background-color: transparent;">
<%
	DecimalFormat availibityFormat = new DecimalFormat("#.###");
	ServiceModel sm = (ServiceModel) request.getSession().getAttribute("Service");
	boolean link = Boolean.parseBoolean(request.getParameter("link"));
	boolean models = Boolean.parseBoolean(request.getParameter("models"));
	if (sm == null) {
%>
<p style="color: red;">Could not load any services</p>
<%
	} else {
%> <!-- 
<%if (sm.getStatus() > -1) {%>
<h1 style="color: <%=sm.getUserStatusColor()%>"><%=sm.getName()%> (Status: <%=sm.getUserStatusString()%>)</h1>
<%} else {%>
<h1><%=sm.getName()%></h1>
<%}%>
 -->
<div class="text">

<table style="width: 100%; background-color: transparent;">
	<col width="5%" />
	<col width="45%" />
	<col width="25%" />
	<col width="35%" />
	<thead style="font-weight: bold;">
		<tr>
			<TD></TD>
			<TD>Service</TD>
			<TD>Verf&uuml;gbarkeit</TD>
			<td>Status</td>
		</tr>
	</thead>
	<tbody>
		<%
			Map<String, Model> children = sm.getChildren();
				for (Map.Entry<String, Model> e : children.entrySet()) {
					Model model = e.getValue();
					boolean serviceModel = model.getModelClass() == 50;
					boolean ref = link && serviceModel;
					if (!models && !serviceModel) {
						continue; // only display services 
					}
		%>
		<tr>
			<td><img style="border: 0px"
				src="images/<%=model.getUserStatusColor()%>.gif"
				title="<%=model.getName()%> is <%=model.getUserStatusString().toLowerCase()%>"></img>
			</td>
			<td>
			<%
				String refUrl = null;
				if (ref) {
					refUrl = "?id="+model.getID();
					if (link) {
						refUrl = refUrl +"&link=true";
					};
					if (models) {
						refUrl = refUrl +"&models=true";
					};
				} else if (!serviceModel) {
					refUrl = "http://"+e.getKey();
				}
				String helpUrl = model.getAttribute(0x12a4b);//Attribute.Description);
				
				String serviceName = e.getKey();
				if (helpUrl != null && ! "".equals(helpUrl.trim()) && !"n.a.".equals(helpUrl)){
					serviceName = "<a target='_parent' href='http://urz.unibas.ch/go/"+helpUrl+"'>"+serviceName+"</a>";
				}
			%>  <%= serviceName %>

			<% 

			if (refUrl != null){
				%> <a href='<%=  refUrl%>'>(goto)</a><% 
			}
			%>
			</td>
			<td>
			<%
				String availString;
						if (serviceModel) {
							float avail = ((ServiceModel) model).getAvailability();
							if (avail > 100) {
								avail = 100;
							}
							availString = availibityFormat.format(avail) + "%";
							if (avail < 0) {
								availString = "n.a."; 
							}
						} else {
							if ("UpsApc92xx".equals(model.getMType())){ 
								try{
									availString = model.getAttributeFromTable(Attribute.APCTemperature,2) + " &deg;C";
									try{
										availString = availString + " ("+model.getAttributeFromTable(0x21d0782,2) + " &deg;C)";
									}catch(Exception e2){
									}
								}catch(Exception e1){
									availString = "";
								}
								if ("".equals( availString )){
									try{
										availString = model.getAttributeFromTable(Attribute.APCTemperatureUPS,2) + " &deg;C";
										try{
											availString = availString + " ("+model.getAttributeFromTable(0x21d0554,2) + " &deg;C)";
										}catch(Exception e2){ 
										}
									}catch(Exception e1){
										availString = "";
									}
								}
							}else{
							availString = "";
							}
						}
			%> <%=availString%></td>
			<td><%=model.getUserStatusString()%> <!-- 
		Status: <%=model.getStatus()%>
	    <%=model.getMType()%>	(0x<%=Integer.toHexString(model.getID())%>)
		ModelClass: <%=model.getModelClass()%>
	 -->
		</tr><hl>
		<%
			} // children
		%>
	</tbody>
</table>
<%
	} // NOT NULL
%>
<p style="width: 460px; padding-top: 20px; font-size: xx-small;">
Die angegebene Verf&uuml;gbarkeit bezieht sich i.d.R. auf den laufenden
Monat.</p>
</div>
</div>
</body>
</html>