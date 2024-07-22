connection: "tpchlooker"

# include all the views
include: "/views/**/*.view.lkml"

datagroup: raman_havetski_looker_intensive_13_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: raman_havetski_looker_intensive_13_default_datagroup

explore: d_customer {}

explore: d_dates {}

explore: d_part {}

explore: d_supplier {}

explore: f_lineitems {
  join:  d_customer{
    type: left_outer
    relationship: many_to_one
    sql_on: ${d_customer.c_custkey} = ${f_lineitems.l_custkey} ;;
  }
  join: d_dates {
    type: left_outer
    relationship: many_to_one
    sql_on: ${d_dates.datekey} = ${f_lineitems.l_orderdatekey} ;;
  }
  join: d_part {
    type: left_outer
    relationship: many_to_one
    sql_on: ${d_part.p_partkey} = ${f_lineitems.l_partkey};;
  }
  join: d_supplier {
    type: left_outer
    relationship: many_to_one
    sql_on: ${d_supplier.s_suppkey} = ${f_lineitems.l_suppkey};;
  }
}
