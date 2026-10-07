# Estimación del beta de Apple frente al S&P 500

Asignación de regresión lineal de Control y Gestión de Riesgos. Se descargan precios desde Yahoo Finance en R, se calculan rendimientos diarios y se estima el beta de Apple Inc. (AAPL) respecto al S&P 500 (^GSPC).

## Datos y método

- Período: 2 de enero de 2024 a 31 de agosto de 2026.
- 667 observaciones diarias alineadas.
- Precio: cierre ajustado.
- Rendimiento: diferencia diaria del logaritmo del precio.
- Modelo: R_AAPL = alfa + beta R_SP500 + error.

## Resultados

| Estadística | Resultado |
|---|---:|
| Alfa diaria | 0.000033 |
| Alfa anual aproximada | 0.83 % |
| Beta | 1.0869 |
| Error estándar del beta | 0.0555 |
| Estadístico t | 19.58 |
| R² | 0.3656 |
| Correlación | 0.6046 |
| Volatilidad anual AAPL | 27.56 % |
| Volatilidad anual S&P 500 | 15.33 % |

## Interpretación

El beta estimado es 1.0869. Durante el período analizado, un cambio diario de 1 % en el S&P 500 estuvo asociado con un cambio promedio aproximado de 1.09 % en Apple en la misma dirección. Al ser mayor que uno, Apple mostró una sensibilidad al mercado ligeramente superior y, por tanto, mayor riesgo sistemático.

El R² de 0.3656 indica que alrededor de 36.6 % de la variación diaria de Apple fue explicada por el índice. El resto responde a factores específicos de la empresa, noticias sectoriales y riesgos no incluidos en un modelo de un solo factor. El beta es histórico y puede cambiar con el período, la frecuencia y el entorno de mercado.

## Ejecución

1. Instalar R.
2. Ejecutar analisis_beta.R.
3. Revisar los archivos generados en resultados/.

El script instala quantmod si es necesario, descarga los precios, estima la regresión y exporta los resultados.

## Referencias

Sharpe, W. F. (1964). Capital asset prices: A theory of market equilibrium under conditions of risk. The Journal of Finance, 19(3), 425–442. https://doi.org/10.1111/j.1540-6261.1964.tb02865.x

Yahoo Finance. (2026). Historical market data for Apple Inc. and the S&P 500. https://finance.yahoo.com/
