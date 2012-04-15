ad_library {
    Procedures in the folder namespace related to content folders.

    @author Peter Marklund
    @cvs-id $Id: folder-procs.tcl,v 1.2 2010/10/19 21:02:09 po34demo Exp $
}

namespace eval folder {}

ad_proc -public -deprecated folder::delete {
    {-folder_id:required}
} {
    Deprecated. See content::folder::delete instead.
    Delete a content folder. If the folder
    to delete has children content items referencing it
    via acs_objects.context_id then this proc will fail.

    @author Peter Marklund
    @see content::folder::delete
} {
    db_exec_plsql delete_folder {}
}
