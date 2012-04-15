ad_page_contract {
    Stops watching a particular file or all files if
    no file is specified.
   
    @param watch_file The file to stop watching.
    @author Jon Salz [jsalz@arsdigita.com]
    @creation-date 17 April 2000
    @cvs-id $Id: file-watch-cancel.tcl,v 1.3 2010/10/19 20:10:02 po34demo Exp $
} {
    {watch_file ""}
    {return_url ""}
}
apm_file_watch_cancel $watch_file

ad_returnredirect $return_url
