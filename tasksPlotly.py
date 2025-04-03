import plotly.express as px
import pandas as pd
df = pd.read_csv("hw4.csv")
# Группируем данные, чтобы посчитать общее количество (quantity) по продукту и стране
grouped = df.groupby(["country", "product"], as_index=False)["quantity"].sum()

# Строим bar chart:
fig = px.bar(
    grouped,
    x="product",       # что будет на оси X
    y="quantity",      # что будет на оси Y
    color="country",   # цветовое различие по странам
    barmode="group",   # режим группировки столбцов
    title="Объём импорта по продуктам и странам"
)
fig.show()
# Для примера, выберем одну страну:
some_country = "USA"
df_country = df[df["country"] == some_country]

# Группируем данные по продукту, суммируем quantity
grouped_country = df_country.groupby("product", as_index=False)["quantity"].sum()

# Строим круговую диаграмму
fig_pie = px.pie(
    grouped_country,
    names="product",
    values="quantity",
    title=f"Доля каждого продукта в общем объёме импорта, {some_country}"
)
fig_pie.show()
fig_bubble = px.scatter(
    df,
    x="price",
    y="quantity",
    size="quantity",     # размер пузырька
    color="country",     # цвет по стране
    hover_name="product",# при наведении мыши будет показывать продукт
    title="Bubble chart: Зависимость quantity от price"
)
fig_bubble.show()
fig_bubble = px.scatter(
    df,
    x="price",
    y="quantity",
    size="quantity",
    color="country",
    hover_name="product",
    animation_frame="year",   # анимация по годам
    animation_group="product",
    title="Bubble chart с анимацией по годам"
)
fig_bubble.show()
fig.write_html("bar_chart.html")
