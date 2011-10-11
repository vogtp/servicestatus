package ch.unibas.spectrum.servicestatus;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import ch.unibas.spectrum.ssorb.access.ServiceAccess;
import ch.unibas.spectrum.ssorb.helper.DomainHelper;
import ch.unibas.spectrum.ssorb.model.ServiceModel;

/**
 * Servlet implementation class ServiceStatus
 */
public class ServiceStatus extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public ServiceStatus() {
		super();
		// TODO Auto-generated constructor stub
	}

	@Override
	public void init() throws ServletException {
		super.init();
		DomainHelper.setSpectroServer("spectrum");
		DomainHelper.setUsername("ServiceStatus");
		// DomainHelper.setPassword("password");
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		processRequest(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		processRequest(request, response);
	}

	private void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();

		String display = request.getParameter("display");
		String jsp = "services.jsp";
		if (display != null && !"".equals(display)) {
			jsp = display + ".jsp";
		} 

		String modelID = request.getParameter("id");
		ServiceModel smNew = null;
		try {
			if (modelID != null) { 
				try {
					smNew = ServiceAccess.getServiceByID(Integer.parseInt(modelID));
				} catch (NumberFormatException e) {
				}
			}
			if (smNew == null) {
				if ("root".equalsIgnoreCase(modelID)) {
					smNew = ServiceAccess.getRoot();
				} else {
					smNew = ServiceAccess.getServiceByID(6361942);
				}
			}
			session.setAttribute("Service", smNew);
		} catch (Throwable e) {
			throw new ServletException(e);
		}

		RequestDispatcher view = request.getRequestDispatcher(jsp);
		view.forward(request, response);

	}
}
