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
	<style type="text/css">
	td { padding-right: 15pt;}
	</style>
</head>
<body >
<!-- <body style="width: 1000px; background-color: #F5F5F3;"> -->
<div style="text-align: left; background-color: transparent;">
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

<table style=" background-color: transparent;">
	<thead style="font-weight: bold;">
		<tr>
			<TD></TD>
			<TD>Service</TD>
			<TD>Temperatur</TD>
			<TD>Max</TD>
			<td>Status</td>
			<td>Sys Location</td>
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
				if (ref) {
			%><a
				href="?id=<%=model.getID()%>&display=infrastruktur<%
						if (link) {%>&link=true<%};
						if (models) {%>&models=true<%};%> ">
			<%
				} else if (!serviceModel) {
					%><a href="http://<%=e.getKey()%>">
				<%
					}
			
			%> <%=e.getKey()%> <%
 	if (ref) {
 %>
			</a>
			<%
				}
			%>
			</td>
			
			<%
				String temperature = "";
				String temperatureMax = "";
						if (serviceModel) {
							float avail = ((ServiceModel) model).getAvailability();
							if (avail > 100) {
								avail = 100;
							}
							temperature = availibityFormat.format(avail) + "%";
							if (avail < 0) {
								temperature = "n.a."; 
							}
						} else {
							if ("UpsApc92xx".equals(model.getMType())){ 
								String[] t = null; 
								try{
									t = model.getAttributeTable(Attribute.APCTemperature);
									try{
										temperatureMax = model.getAttributeFromTable(Attribute.APCTemperatureHighTresh,2) + " &deg;C";
									}catch(Exception e2){
									}
								}catch(Exception e1){
									
									temperature = ""; 
								}
								if (t == null){
									try{
										t = model.getAttributeTable(Attribute.APCTemperatureUPS);
										try{
											temperatureMax = model.getAttributeFromTable(Attribute.APCTemperatureUpsHighTresh,2) + " &deg;C";
										}catch(Exception e2){ 
										}
									}catch(Exception e1){
										temperature = "";
									}
								}
								if (t != null){
									String lastValue = ""; 
									for (int i = 0; i<t.length;i = i+2){
										String ti = t[i];
										if (!lastValue.equals(ti)){
											temperature = temperature + ti + " ";
											lastValue = ti; 
										}
									}
								}
								if (!"".equals(temperature.trim())){
									temperature = temperature + "&deg;C";
								}
							}else{
							temperature = "";
							}
						}
			%> 
			<td><%=temperature%></td>
			<td><%=temperatureMax%></td>
			<td><%=model.getUserStatusString()%> </td>
			<%

			try{
				String loc = "";
				loc = model.getAttribute(Attribute.DeviceLocation);
				%><td> <%
				String text = "";
				if (loc != null) {
					int idx = loc.indexOf("https://");
					if (idx == -1){
						loc.indexOf("http://");
					}
					if (idx > -1){
						String disp = "";
						if (idx > 0){
							disp = loc.substring(0, idx);
							loc = loc.substring(idx, loc.length()).replace(" -", "");
						}
						text = "<a href='"+loc+"'>"+disp+"</a>";
					}else{
						text = loc;
					}
					
				%><% 
				}
				
				%><%=text %><%
				
				%></td><% 
			}catch(Exception e2){
			}
			%>
			
			
			<!-- 
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