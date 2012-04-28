ad_library {

    Callback procs for grom-custom package

    @author Iuri Sampaio (iuri.sampaio@iurix.com)
    @creation-date 2012-04-22
}


ad_proc -public -callback im_timesheet_task_after_create -impl grom-custom {
    {-object_id:required}
    {-status_id ""}
    {-type_id ""}
    {-task_id ""}
    {-project_id ""}
} {

    Callback to send information to OpenBravo about a billable task opened on \]PO\[

} {

    ns_log Notice "Running ad_proc im_timesheet_task_after_create"
    set url "http://localhost:8080/openbravo/ws/dal/Country/106"
    set result [ns_httpget $url 60 0]

    
    return
}



ad_proc -public -callback im_timesheet_task_after_update -impl grom-custom {
    {-object_id:required}
    {-status_id ""}
    {-type_id ""}
    {-task_id ""}
    {-project_id ""}
} {

    Callback to send information to OpenBravo about a billable task opened on \]PO\[

} {

    ns_log Notice "Running ad_proc im_timesheet_task_after_create"
    set url "http://localhost:8080/openbravo/ws/dal/Country/106"
    set result [ns_httpget $url 60 0]

    
    return
}