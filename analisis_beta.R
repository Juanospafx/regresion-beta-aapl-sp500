# Estimación del beta de Apple frente al S&P 500
# Asignatura: NEG-LIF309-01 Control y Gestión de Riesgos
# Estudiante: Juan Pablo Estevez Borja

if (!requireNamespace("quantmod", quietly = TRUE)) {
  install.packages("quantmod", repos = "https://cloud.r-project.org")
}
library(quantmod)

fecha_inicio <- as.Date("2024-01-01")
fecha_fin <- as.Date("2026-09-01")

getSymbols(c("AAPL", "^GSPC"), src = "yahoo",
           from = fecha_inicio, to = fecha_fin, auto.assign = TRUE)

# Cierres ajustados y rendimientos logarítmicos diarios
precios <- na.omit(merge(Ad(AAPL), Ad(GSPC)))
colnames(precios) <- c("AAPL", "SP500")
rendimientos <- na.omit(diff(log(precios)))
colnames(rendimientos) <- c("AAPL", "SP500")
datos <- data.frame(fecha = index(rendimientos),
                    AAPL = as.numeric(rendimientos$AAPL),
                    SP500 = as.numeric(rendimientos$SP500))

# Modelo de mercado por mínimos cuadrados ordinarios
modelo <- lm(AAPL ~ SP500, data = datos)
resumen <- summary(modelo)
alfa <- unname(coef(modelo)["(Intercept)"])
beta <- unname(coef(modelo)["SP500"])
r_cuadrado <- resumen$r.squared
error_beta <- resumen$coefficients["SP500", "Std. Error"]
t_beta <- resumen$coefficients["SP500", "t value"]
correlacion <- cor(datos$AAPL, datos$SP500)
vol_aapl <- sd(datos$AAPL) * sqrt(252)
vol_sp500 <- sd(datos$SP500) * sqrt(252)

cat("Observaciones:", nrow(datos), "\n")
cat("Alfa diaria:", round(alfa, 8), "\n")
cat("Beta:", round(beta, 6), "\n")
cat("R cuadrado:", round(r_cuadrado, 6), "\n")
cat("Correlación:", round(correlacion, 6), "\n\n")
print(resumen)

if (beta > 1) {
  interpretacion <- paste0("El beta de ", round(beta, 4),
    " indica que AAPL fue más sensible que el mercado. Un movimiento diario de 1% en el S&P 500 se asoció con un movimiento promedio de ",
    round(beta, 2), "% en AAPL en la misma dirección.")
} else if (beta > 0) {
  interpretacion <- paste0("El beta de ", round(beta, 4),
    " indica que AAPL se movió en la misma dirección que el mercado, pero con menor sensibilidad.")
} else {
  interpretacion <- paste0("El beta de ", round(beta, 4),
    " indica una relación inversa con el mercado durante el período estudiado.")
}
cat("\nInterpretación:\n", interpretacion, "\n")

dir.create("resultados", showWarnings = FALSE)
write.csv(datos, "resultados/rendimientos_utilizados.csv", row.names = FALSE)
write.csv(data.frame(
  estadistica = c("observaciones", "alfa_diaria", "alfa_anual_aproximada", "beta",
    "error_estandar_beta", "t_beta", "r_cuadrado", "correlacion",
    "volatilidad_anual_aapl", "volatilidad_anual_sp500"),
  valor = c(nrow(datos), alfa, alfa * 252, beta, error_beta, t_beta,
    r_cuadrado, correlacion, vol_aapl, vol_sp500)
), "resultados/resumen_modelo.csv", row.names = FALSE)
capture.output(resumen, file = "resultados/resumen_regresion.txt")

png("resultados/regresion_aapl_sp500.png", width = 1200, height = 800, res = 140)
plot(datos$SP500, datos$AAPL, pch = 16,
     col = rgb(31, 78, 120, 90, maxColorValue = 255),
     xlab = "Rendimiento diario del S&P 500",
     ylab = "Rendimiento diario de AAPL",
     main = "Regresión de AAPL frente al S&P 500")
abline(modelo, col = "firebrick", lwd = 2)
grid()
dev.off()
