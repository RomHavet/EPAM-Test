view: f_lineitems {
  sql_table_name: "DATA_MART"."F_LINEITEMS" ;;

  dimension: l_availqty {
    type: number
    sql: ${TABLE}."L_AVAILQTY" ;;
  }
  dimension: l_clerk {
    type: string
    sql: ${TABLE}."L_CLERK" ;;
  }
  dimension: l_commitdatekey {
    type: number
    sql: ${TABLE}."L_COMMITDATEKEY" ;;
  }
  dimension: l_custkey {
    type: number
    sql: ${TABLE}."L_CUSTKEY" ;;
  }
  dimension: l_discount {
    type: number
    sql: ${TABLE}."L_DISCOUNT" ;;
  }
  dimension: l_extendedprice {
    type: number
    sql: ${TABLE}."L_EXTENDEDPRICE" ;;
  }
  dimension: l_linenumber {
    type: number
    primary_key: yes
    sql: ${TABLE}."L_LINENUMBER" ;;
  }
  dimension: l_orderdatekey {
    type: number
    sql: ${TABLE}."L_ORDERDATEKEY" ;;
  }
  dimension: l_orderkey {
    type: number
    sql: ${TABLE}."L_ORDERKEY" ;;
  }
  dimension: l_orderpriority {
    type: string
    sql: ${TABLE}."L_ORDERPRIORITY" ;;
  }
  dimension: l_orderstatus {
    type: string
    sql: ${TABLE}."L_ORDERSTATUS" ;;
  }
  dimension: l_partkey {
    type: number
    sql: ${TABLE}."L_PARTKEY" ;;
  }
  dimension: l_quantity {
    type: number
    sql: ${TABLE}."L_QUANTITY" ;;
  }
  dimension: l_receiptdatekey {
    type: number
    sql: ${TABLE}."L_RECEIPTDATEKEY" ;;
  }
  dimension: l_returnflag {
    type: string
    sql: ${TABLE}."L_RETURNFLAG" ;;
  }
  dimension: l_shipdatekey {
    type: number
    sql: ${TABLE}."L_SHIPDATEKEY" ;;
  }
  dimension: l_shipinstruct {
    type: string
    sql: ${TABLE}."L_SHIPINSTRUCT" ;;
  }
  dimension: l_shipmode {
    type: string
    sql: ${TABLE}."L_SHIPMODE" ;;
  }
  dimension: l_shippriority {
    type: number
    sql: ${TABLE}."L_SHIPPRIORITY" ;;
  }
  dimension: l_suppkey {
    type: number
    sql: ${TABLE}."L_SUPPKEY" ;;
  }
  dimension: l_supplycost {
    type: number
    sql: ${TABLE}."L_SUPPLYCOST" ;;
  }
  dimension: l_tax {
    type: number
    sql: ${TABLE}."L_TAX" ;;
  }
  dimension: l_totalprice {
    type: number
    sql: ${TABLE}."L_TOTALPRICE" ;;
  }
  measure: count {
    type: count
  }
  measure: total_sale_price {
    description: "Sum of all transactions prices"
    type: sum
    sql: ${l_totalprice};;
    value_format_name: usd
  }
  measure: average_sale_price {
    description: "Average transactions price"
    type: average
    sql: ${l_totalprice};;
    value_format_name: usd
  }
  measure: cumulative_total_price {
    description: "Cumulative sum of all transactions prices up to date"
    type: number
    sql: SUM(${l_totalprice}) OVER (ORDER BY ${l_orderdatekey} ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) ;;
    value_format_name: usd
  }

  measure: total_quantity_sold {
    description: "Sum of all quantities sold"
    type: sum
    sql: ${l_quantity};;
  }

  measure: total_sale_price_shipped_by_air {
  description: "Total sales of items shipped by air"
  type: sum
  sql: ${l_totalprice};;
  filters: [l_shipmode: "AIR"
  ]
  value_format_name: usd
}
measure: total_russia_sales {
  description: "Total sales by customers from Russia"
  type: sum
  sql: ${l_totalprice} ;;
  filters: [d_customer.c_nation: "RUSSIA"]
  value_format_name: usd
}
  measure: total_gross_revenue {
    type: sum
    sql: ${l_totalprice} ;;
    filters: {
      field: receipt_dates.date_val_date
      value: "before today"
    }

  }

}
