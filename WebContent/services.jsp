<%@ page language="java" contentType="text/html; charset=US-ASCII"
    pageEncoding="US-ASCII"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="ch.unibas.spectrum.ssorb.model.ServiceModel"%>
<%@page import="java.util.Map"%>
<%@page import="ch.unibas.spectrum.ssorb.model.Model"%>
<html >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
<title>Spectrum Services</title>
<link rel="stylesheet" type="text/css" href="http://urz.unibas.ch/css/master.css">
<link rel="stylesheet" type="text/css" href="http://urz.unibas.ch/css/unibas.css">
<link rel="stylesheet" type="text/css" href="http://urz.unibas.ch/css/lightbox.css" />
<link rel="stylesheet" type="text/css" href="http://urz.unibas.ch/css/main.css" title="Default Style" media="screen" />
</head>
<body style="background-color: #F5F5F3;">
<div id='content' style="text-align: left; background-color: transparent;" > 
<%
ServiceModel sm = (ServiceModel)request.getSession().getAttribute("Service");
boolean link = Boolean.parseBoolean(request.getParameter("link"));
if (sm == null){
%> 
<p style="color: red;">Could not load any services</p>
<%} else { %>
<!-- 
<% if (sm.getStatus() > -1) { %>
<h1 style="color: <%= sm.getUserStatusColor() %>"><%= sm.getName()%> (Status: <%=sm.getUserStatusString()%>)</h1>
<%} else { %>
<h1><%= sm.getName()%></h1>
<% } %>
 -->
<div class="text">

<table style="width: 100%; background-color: transparent;">
  <col width="5%" />
  <col width="65%" />
  <col width="30%" />
<thead style="font-weight: bold;">
<tr><TD></TD><TD>Service</TD><td>Status</td></tr>
</thead>
<tbody>
<%
Map<String, Model> children = sm.getChildren();
for (Map.Entry<String, Model> e : children.entrySet()) {
	Model model = e.getValue();
	boolean serviceModel = model.getModelClass() == 50;
	boolean ref = link && serviceModel;
	if (!serviceModel){
		continue; // only display services 
	}
%>
<tr>
<td>	<img style="border: 0px" src="images/<%= model.getUserStatusColor() %>.gif" title="<%= model.getName() %> is <%= model.getUserStatusString().toLowerCase() %>"></img> </td>
<td>		<% if (ref) { %><a href="?id=<%=model.getID() %><% if(link){ %>&link=true<%}%> "> <%} %>
		 	<%= e.getKey() %> 
		 <% if (ref) { %></a><%} %>
</td>
<td>		 <%=model.getUserStatusString()  %>
<!-- 
		Status: <%= model.getStatus() %>
	    <%= model.getMType() %>	(0x<%= Integer.toHexString(model.getID()) %>)
		ModelClass: <%= model.getModelClass() %>
	 -->
		
</tr>
<% } // children %>
</tbody>
</table>
<% } // NOT NULL %>
</div></div></body>
</html>