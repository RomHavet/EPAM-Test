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
    label: "Total Sales"
    description: "Sum of all transactions prices"
    type: sum
    sql: ${l_totalprice};;
    value_format_name: usd
  }
  measure: average_sale_price {
    label: "Average Sales"
    description: "Average transactions price"
    type: average
    sql: ${l_totalprice};;
    value_format_name: usd
  }
  measure: cumulative_total_price {
    label: "Cumulative Total Sales"
    description: "Cumulative sum of all transactions prices up to date"
    type: number
    sql: SUM(${l_totalprice}) OVER (ORDER BY ${l_orderdatekey} ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) ;;
    value_format_name: usd
  }

  measure: total_quantity_sold {
    label: "Total Number of Items Sold"
    description: "Number of items that were sold"
    type: sum
    sql: ${l_quantity};;
  }

  measure: total_sale_price_shipped_by_air {
    label: "Total Sales Shipped by Air"
    description: "Total sales of items shipped by air"
    type: sum
    sql: ${l_totalprice};;
    filters: [l_shipmode: "AIR"
    ]
    value_format_name: usd
  }
  measure: total_russia_sales {
    label: "Total Sales to Russia"
    description: "Total sales by customers from Russia"
    type: sum
    sql: ${l_totalprice} ;;
    filters: [d_customer.c_nation: "RUSSIA"]
    value_format_name: usd
  }
  measure: total_gross_revenue {
    label: "Total Gross Revenue"
    description: "Total sales whith order status F (completed)"
    type: sum
    sql: ${l_totalprice} ;;
    filters: [l_orderstatus: "F"]
    value_format_name: usd
    drill_fields: [revenue_details*]
  }
  measure: total_cost {
    label: "Total Cost"
    description: "Total supply cost"
    type: sum
    sql: ${l_supplycost} ;;
    value_format_name: usd
  }
  measure: total_gross_margin_amount {
    label: "Total Gross Margin"
    description: "Total Gross Revenue – Total Cost"
    type: number
    sql: ${total_gross_revenue} - ${total_cost} ;;
    value_format_name: usd
    drill_fields: [ supplier_details*]
  }
  measure: gross_margin_percentage {
    label: "Gross Margin Percentage"
    description: "Total Gross Margin Amount / Total Gross Revenue"
    sql: ${total_gross_margin_amount} / NULLIF(${total_gross_revenue},0) ;;
    value_format_name: percent_2
    drill_fields: [item_details*]
  }
  measure: total_items_returned {
    label: "Number of Items Returned"
    description: "Number of items that were returned by dissatisfied customers"
    type:  sum
    sql: ${l_quantity} ;;
    filters: [l_returnflag: "R" ]
  }
  measure: items_return_rate {
    label: "Item Return Rate"
    description: "Number Of Items Returned / Total Number Of Items Sold"
    type: number
    sql: ${total_items_returned} / NULLIF(${total_quantity_sold},0) ;;
    value_format_name: percent_2
  }
  measure: total_customers_count {
    description: "Total number of customers"
    hidden:  yes
    type: count_distinct
    sql: ${l_custkey} ;;
  }
  measure: avg_spend_per_customer {
    label: "Average Spend per Customer"
    description: "Total Sale Price / Total Number of Customers"
    sql: ${total_sale_price} / NULLIF(${total_customers_count},0) ;;
    value_format_name: usd
  }
  set: supplier_details {
    fields: [ d_supplier.s_region,
              d_supplier.c_account_balance_cohort,
              total_gross_margin_amount]
  }
  set: revenue_details {
    fields: [ d_customer.c_nation,
              d_dates.set*,
              total_gross_revenue]

  }
  set: item_details {
    fields: [ d_part.Brand,
              d_part.Name,
              total_gross_margin_amount]
  }
}
