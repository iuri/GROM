ad_page_contract {

    @author yon (yon@openforce.net)
    @creation-date 2002-05-13
    @cvs-id $Id: index.tcl,v 1.1.1.1 2005/12/03 18:22:44 cvs Exp $

} -query {
    {orderby "send_date*,subject"}
} -properties {
    title:onevalue
    context:onevalue
    table:onevalue
}

set package_id [ad_conn package_id]

permission::require_permission -object_id $package_id -privilege admin

set title [string totitle [bulk_mail::pretty_name]]

set table_def [list \
                   [list send_date [_ bulk-mail.Send_Date] {bulk_mail_messages.send_date $order} {<td width="10%">[lc_time_fmt $send_date "%q"]</td>}] \
                   [list from_addr [_ bulk-mail.From] {bulk_mail_messages.from_addr $order} {<td width="15%">$from_addr</td>}] \
                   [list subject [_ bulk-mail.Subject] {bulk_mail_messages.subject $order} {<td><a href="[lindex [site_node::get_url_from_object_id -object_id $package_id] 0]one?bulk_mail_id=$bulk_mail_id">$subject</a></td>}] \
                   [list status [_ bulk-mail.Status] {bulk_mail_messages.status $order} {<td width="10%" align="center">[ad_decode $status sent [_ bulk-mail.Sent] pending [_ bulk-mail.Pending] [_ bulk-mail.Cancelled]]</td>}] \
                  ]

set sql "
    select bulk_mail_messages.*
    from bulk_mail_messages
    where bulk_mail_messages.package_id = :package_id
    [ad_order_by_from_sort_spec $orderby $table_def]
"

set table [ad_table \
    -Tmissing_text "<blockquote><i>[_ bulk-mail.lt_No_bulk_mail_messages]</i></blockquote>" \
    -Torderby $orderby \
    -Ttable_extra_html {width="95%"} \
    select_bulk_mail_messages \
    $sql \
    $table_def \
]

ad_return_template
