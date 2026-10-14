# 📊 Data Science Salary Analysis & Hypothesis Testing

## 📌 Project Overview
Questo progetto esplora le dinamiche retributive nel settore Data Science e Analytics utilizzando il dataset `ds_salaries`. 
L'obiettivo principale non è soltanto la visualizzazione descrittiva dei dati, ma la **validazione formale delle ipotesi statistiche** per verificare l'impatto del livello di esperienza e della categoria professionale sulla retribuzione annua (USD).

---

## 🛠️ Tech Stack & Tools
* **Language:** R
* **Libraries:** `tidyverse` (`dplyr`, `ggplot2`, `stringr`)
* **Statistical Methods:**
  * Exploratory Data Analysis (EDA)
  * Welch's Two-Sample $T$-Test
  * One-Way ANOVA (Analysis of Variance)
  * Tukey's Honest Significant Difference (HSD) Post-Hoc Test

---

## 🔬 Key Statistical Findings

### 1. Impatto dell'Esperienza: Mid-Level vs Senior ($T$-Test)
* **Ipotesi:** Verificare se i profili Senior (`SE`) percepiscono un salario significativamente superiore rispetto ai profili Mid-Level (`MI`).
* **Risultato:** Welch's $T$-Test ($p\text{-value} < 0.001$).
* **Conclusione:** Rifiuto netto dell'ipotesi nulla. Il premio salariale medio per i profili Senior è di circa **$48.500 USD/anno** rispetto ai Mid-Level.

### 2. Differenze tra Macro-Categorie Professionali (ANOVA & Tukey HSD)
* **Feature Engineering:** I singoli job title (oltre 40) sono stati aggregati tramite regex in 5 macro-categorie: *Data Scientist*, *Data Engineer*, *Data Analyst*, *ML/AI Engineer*, *Management/Other*.
* **ANOVA:** $F = 43.5$, $p\text{-value} < 0.001$. Indica la presenza di differenze significative tra le categorie.
* **Tukey HSD Test:**
  * La varianza è guidata dai **Data Analyst**, i quali mostrano una retribuzione mediamente inferiore di circa **$32.000 USD** rispetto a tutte le altre categorie ($p < 0.001$).
  * Non si registrano invece differenze statisticamente significative tra **Data Scientist**, **Data Engineer** e **ML Engineer** ($p > 0.05$).

---

## 🚀 Next Steps
Il progetto verrà esteso in **Python** per lo sviluppo di modelli di Machine Learning (Regressione Lineare, Random Forest) con l'obiettivo di predire lo stipendio in base alle caratteristiche del profilo lavorativo.
