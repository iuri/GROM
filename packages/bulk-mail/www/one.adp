<master>
<property name="title">@title;noquote@</property>
<property name="context">@context;noquote@</property>

<if @status@ eq "pending">
#bulk-mail.Message_not_sent_yet#
</if>
  <table bgcolor="#ececec" border="1" width="95%" cellpadding="3" cellspacing="3">
    <tr>
      <td>#bulk-mail.Send_Date#</td>
      <td><if @send_date@ not nil>@send_date@</if><else>&nbsp;</else></td>
    </tr>
    <tr>
      <td>#bulk-mail.From#</td>
      <td><if @from_addr@ not nil>@from_addr@</if><else>&nbsp;</else></td>
    </tr>
    <tr>
      <td>#bulk-mail.Subject#</td>
      <td><if @subject@ not nil><pre>@subject@</pre></if><else>&nbsp;</else></td>
    </tr>
    <tr>
      <td>#bulk-mail.Reply_To#</td>
      <td><if @reply_to@ not nil>@reply_to@</if><else>&nbsp;</else></td>
    </tr>
    <tr>
      <td>#bulk-mail.Extra_Headers#</td>
      <td><if @extra_headers@ not nil>@extra_headers@</if><else>&nbsp;</else></td>
    </tr>
    <tr>
      <td>#bulk-mail.Message#</td>
      <td><if @message@ not nil><pre>@message;noquote@</pre></if><else>&nbsp;</else></td>
    </tr>
    <tr>
      <td>#bulk-mail.Query#</td>
      <td><if @query@ not nil><pre>@query@</pre></if><else>&nbsp;</else></td>
    </tr>
    <tr>
      <td>#bulk-mail.Status#</td>
      <td><if @status@ eq sent>#bulk-mail.Sent#</if><elseif @status@ eq pending>#bulk-mail.Pending#</elseif><else>#bulk-mail.Cancelled#</else></td>
    </tr>
  </table>

