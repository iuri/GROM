ad_page_contract {
  Re-source a test init file with test case definitions to
  avoid server restart.

  @author Peter Marklund

  @cvs-id $Id: init-file-resource.tcl,v 1.2 2010/10/19 20:10:28 po34demo Exp $
} {
    absolute_file_path
    return_url
}

ns_log Notice "Sourcing test definition file $absolute_file_path"
apm_source $absolute_file_path

ad_returnredirect $return_url
