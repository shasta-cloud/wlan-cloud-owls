//
// Created by stephane bourque on 2021-10-23.
//

#include "framework/MicroService.h"
#include "RESTAPI/RESTAPI_deviceDashboardHandler.h"
#include "RESTAPI/RESTAPI_operation_handler.h"
#include "RESTAPI/RESTAPI_results_handler.h"
#include "RESTAPI/RESTAPI_simulation_handler.h"
#include "RESTAPI/RESTAPI_status_handler.h"

namespace OpenWifi {

    Poco::Net::HTTPRequestHandler * RESTAPI_external_server(const char *Path, RESTAPIHandler::BindingMap &Bindings,
                                                            Poco::Logger & L, RESTAPI_GenericServer & S) {
        return  RESTAPI_Router<
                    RESTAPI_system_command,
                    RESTAPI_deviceDashboardHandler,
                    RESTAPI_operation_handler,
                    RESTAPI_results_handler,
                    RESTAPI_simulation_handler,
                    RESTAPI_status_handler
                >(Path,Bindings,L, S);
    }

    Poco::Net::HTTPRequestHandler * RESTAPI_internal_server(const char *Path, RESTAPIHandler::BindingMap &Bindings,
                                                            Poco::Logger & L, RESTAPI_GenericServer & S) {
        return RESTAPI_Router_I<
                RESTAPI_operation_handler,
                RESTAPI_results_handler,
                RESTAPI_simulation_handler,
                RESTAPI_system_command
            >(Path, Bindings, L, S);
    }
}