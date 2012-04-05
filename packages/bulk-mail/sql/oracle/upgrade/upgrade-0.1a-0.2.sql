alter table bulk_mail_messages add (temp clob constraint temp_nn not null);
update bulk_mail_messages set temp = query;
alter table bulk_mail_messages drop column query cascade constraints;

alter table bulk_mail_messages add (query clob constraint bm_messages_query_nn not null);
update bulk_mail_messages set query = temp;
alter table bulk_mail_messages drop column temp cascade constraints;
