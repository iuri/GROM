ad_library {

    Callback procs for grom-custom package

    @author Iuri Sampaio (iuri.sampaio@iurix.com)
    @creation-date 2012-04-22
}

namespace eval grom:: {}

ad_proc -public -callback im_timesheet_task_new_billable_task -impl grom-custom {
    {-object_id:required}
    {-status_id ""}
    {-type_id ""}
    {-task_id ""}
    {-project_id ""}
    {... all info about a timesheet_task}
} {

    Callback to send information to OpenBravo about a billable task opened on \]PO\[

} {


    db_exec_plsql im_timesheet_task_new_billable_task {

    }


    return
}