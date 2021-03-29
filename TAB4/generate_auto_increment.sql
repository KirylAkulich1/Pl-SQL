create or replace function generate_auto_increment 
(
  table_name in varchar2 
) return varchar2 as 
 auto_increment_script VARCHAR(1000);
begin
    auto_increment_script := 'CREATE SEQUENCE ' || table_name || '_pk_seq' || ';';
    auto_increment_script :=  auto_increment_script ||  'create or replace trigger ' || table_name ||
	'   before insert on ' || table_name || 
	'   for each row '||
	'begin  ' ||
	'   if inserting then ' ||
	'      if :NEW."ID" is null then ' ||
	'         select ' || table_name || '_pk_seq'  || '.nextval into :NEW."ID" from dual; '||
	'      end if; '||
	'   end if; '||
	'end';
  return auto_increment_script;
end generate_auto_increment;