view: order_items {
  derived_table: {
    sql: SELECT
            "L_AVAILQTY" AS l_availqty,
            "L_CLERK" AS l_clerk,
            "L_COMMITDATEKEY" AS l_commitdatekey,
            "L_CUSTKEY" AS l_custkey,
            "L_DISCOUNT" AS l_discount,
            "L_EXTENDEDPRICE" AS l_extendedprice,
            "L_LINENUMBER" AS l_linenumber,
            "L_ORDERDATEKEY" AS l_orderdatekey,
            "L_ORDERKEY" AS l_orderkey,
            "L_ORDERPRIORITY" AS l_orderpriority,
            "L_ORDERSTATUS" AS l_orderstatus,
            "L_PARTKEY" AS l_partkey,
            "L_QUANTITY" AS l_quantity,
            "L_RECEIPTDATEKEY" AS l_receiptdatekey,
            "L_RETURNFLAG" AS l_returnflag,
            "L_SHIPDATEKEY" AS l_shipdatekey,
            "L_SHIPINSTRUCT" AS l_shipinstruct,
            "L_SHIPMODE" AS l_shipmode,
            "L_SHIPPRIORITY" AS l_shippriority,
            "L_SUPPKEY" AS l_suppkey,
            "L_SUPPLYCOST" AS l_supplycost,
            "L_TAX" AS l_tax,
            "L_TOTALPRICE" AS l_totalprice
          FROM "DATA_MART"."F_LINEITEMS" ;;
    datagroup_trigger: raman_havetski_looker_intensive_13_default_datagroup
  }

  dimension: l_availqty {
    type: number
    sql: ${TABLE}.l_availqty ;;
  }
  dimension: l_clerk {
    type: string
    sql: ${TABLE}.l_clerk ;;
  }
  dimension: l_commitdatekey {
    type: number
    sql: ${TABLE}.l_commitdatekey ;;
  }
  dimension: l_custkey {
    type: number
    sql: ${TABLE}.l_custkey ;;
  }
  dimension: l_discount {
    type: number
    sql: ${TABLE}.l_discount ;;
  }
  dimension: l_extendedprice {
    type: number
    sql: ${TABLE}.l_extendedprice ;;
  }
  dimension: l_linenumber {
    type: number
    primary_key: yes
    sql: ${TABLE}.l_linenumber ;;
  }
  dimension: l_orderdatekey {
    type: number
    sql: ${TABLE}.l_orderdatekey ;;
  }
  dimension: l_orderkey {
    type: number
    sql: ${TABLE}.l_orderkey ;;
  }
  dimension: l_orderpriority {
    type: string
    sql: ${TABLE}.l_orderpriority ;;
  }
  dimension: l_orderstatus {
    type: string
    sql: ${TABLE}.l_orderstatus ;;
  }
  dimension: l_partkey {
    type: number
    sql: ${TABLE}.l_partkey ;;
  }
  dimension: l_quantity {
    type: number
    sql: ${TABLE}.l_quantity ;;
  }
  dimension: l_receiptdatekey {
    type: number
    sql: ${TABLE}.l_receiptdatekey ;;
  }
  dimension: l_returnflag {
    type: string
    sql: ${TABLE}.l_returnflag ;;
  }
  dimension: l_shipdatekey {
    type: number
    sql: ${TABLE}.l_shipdatekey ;;
  }
  dimension: l_shipinstruct {
    type: string
    sql: ${TABLE}.l_shipinstruct ;;
  }
  dimension: l_shipmode {
    type: string
    sql: ${TABLE}.l_shipmode ;;
  }
  dimension: l_shippriority {
    type: number
    sql: ${TABLE}.l_shippriority ;;
  }
  dimension: l_suppkey {
    type: number
    sql: ${TABLE}.l_suppkey ;;
  }
  dimension: l_supplycost {
    type: number
    sql: ${TABLE}.l_supplycost ;;
  }
  dimension: l_tax {
    type: number
    sql: ${TABLE}.l_tax ;;
  }
  dimension: l_totalprice {
    type: number
    sql: ${TABLE}.l_totalprice ;;
  }
  measure: count {
    type: count
  }
  measure: total_sale_price {
    label: "Total Sales"
    description: "Sum of all transactions prices"
    type: sum
    sql: ${l_totalprice} ;;
    value_format_name: usd
  }
  measure: average_sale_price {
    label: "Average Sales"
    description: "Average transactions price"
    type: average
    sql: ${l_totalprice} ;;
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
    sql: ${l_quantity} ;;
  }
  measure: total_sale_price_shipped_by_air {
    label: "Total Sales Shipped by Air"
    description: "Total sales of items shipped by air"
    type: sum
    sql: ${l_totalprice} ;;
    filters: [l_shipmode: "AIR"]
    value_format_name: usd
  }
  measure: total_gross_revenue {
    label: "Total Gross Revenue"
    description: "Total sales with order status F (completed)"
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
    drill_fields: [supplier_details*]
  }
  measure: gross_margin_percentage {
    label: "Gross Margin Percentage"
    description: "Total Gross Margin Amount / Total Gross Revenue"
    sql: ${total_gross_margin_amount} / NULLIF(${total_gross_revenue},0) ;;
    value_format_name: percent_2
    drill_fields: [item_details*]
  }
  measure: total_items_sold {
    label: "Number of Items Sold"
    description: "Number of items that were sold"
    type: sum
    sql: ${l_quantity} ;;
  }
  measure: total_items_returned {
    label: "Number of Items Returned"
    description: "Number of items that were returned by dissatisfied customers"
    type: sum
    sql: ${l_quantity} ;;
    filters: [l_returnflag: "R"]
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
    hidden: yes
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
    fields: [d_supplier.s_region, d_supplier.c_account_balance_cohort, total_gross_margin_amount]
  }
  set: revenue_details {
    fields: [d_customer.c_nation, d_dates.set*, total_gross_revenue]
  }
  set: item_details {
    fields: [d_part.p_brand, d_part.p_name, total_gross_margin_amount]
  }
}
