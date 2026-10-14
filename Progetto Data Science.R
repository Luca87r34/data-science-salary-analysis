# 1. Installa e carica il pacchetto principale (da fare solo la prima volta)
install.packages("tidyverse")
library(tidyverse)

# Disabilita la notazione scientifica (es. rimuove 4e+05 sui grafici)
options(scipen = 999)


# 2. Leggi il file CSV (equivalente di pd.read_csv)
df <- read_csv("ds_salaries(1).csv")

# 3. Guarda le prime righe (equivalente di df.head())
head(df)

#Struttura del dataset e tipo di variabili
glimpse(df)

#Sintesi statistica veloce delle variabili
summary(df)


#Pulizia e selezione delle colonne principali
df_selezionato <- df %>% 
  select(work_year, experience_level, employment_type, job_title, salary_in_usd, remote_ratio, company_location)

#Grafico distribuzione dei salari

ggplot(df_selezionato,aes(x=salary_in_usd)) + geom_histogram(bins=30,fill="steelblue", color="white") + theme_minimal() +
  labs(
    title="Distribuzione degli Stipendi in Data Science", 
    x="Stipendio (USD)",
    y="Frequenza"
  )


ggplot(df_selezionato, aes(x = experience_level, y = salary_in_usd, fill = experience_level)) +
  geom_boxplot() +
  theme_minimal() +
  labs(
    title = "Distribuzione degli Stipendi per Livello di Esperienza",
    x = "Livello di Esperienza (EN=Entry, MI=Mid, SE=Senior, EX=Executive)",
    y = "Stipendio (USD)"
  )


# 1. Filtriamo il dataset prendendo solo le categorie 'MI' e 'SE'
df_sub <- df_selezionato %>% 
  filter(experience_level %in% c("MI", "SE"))

# 2. Calcoliamo media, deviazione standard e numero di osservazioni per gruppo
df_sub %>% 
  group_by(experience_level) %>% 
  summarise(
    Media_Stipendio = mean(salary_in_usd),
    Deviazione_Std = sd(salary_in_usd),
    Conteggio = n()
  )

# 3. Eseguiamo il T-Test a due campioni (Welch's Two Sample t-test)
risultato_test <- t.test(
  salary_in_usd ~ experience_level, 
  data = df_sub,
  alternative = "two.sided",
  conf.level = 0.95 # Opzionale: 0.95 è già il valore predefinito
)

# 4. Stampiamo il risultato del test
print(risultato_test)


#È stato condotto un Welch's Two-Sample T-Test per verificare l'impatto dell'esperienza
#lavorativa sul salario. I risultati indicano una differenza statisticamente significativa
#($p < 0.001$) tra la retribuzione media dei profili Mid-level ($\mu \approx 104.526$ USD)
#e Senior ($\mu \approx 153.051$ USD), confermando un premio salariale netto per i profili Senior.



library(tidyverse)

# 1. Creazione delle macro-categorie di ruoli
df_grouped <- df_selezionato %>%
  mutate(
    job_category = case_when(
      str_detect(job_title, "Data Scientist|Science") ~ "Data Scientist",
      str_detect(job_title, "Data Engineer|Architect|Infrastructure") ~ "Data Engineer",
      str_detect(job_title, "Data Analyst|BI|Analytics|Visualization") ~ "Data Analyst",
      str_detect(job_title, "Machine Learning|ML|AI|Deep Learning") ~ "ML / AI Engineer",
      TRUE ~ "Management / Other"
    )
  )

# 2. Contiamo quante osservazioni ci sono per ogni macro-categoria
df_grouped %>% 
  count(job_category, sort = TRUE)


# Tabella riassuntiva per macro-categoria
statistiche_ruoli <- df_grouped %>%
  group_by(job_category) %>%
  summarise(
    Conteggio = n(),
    Media_Stipendio = round(mean(salary_in_usd), 2),
    Mediana_Stipendio = round(median(salary_in_usd), 2),
    Deviazione_Std = round(sd(salary_in_usd), 2)
  ) %>%
  arrange(desc(Media_Stipendio))

print(statistiche_ruoli)



ggplot(df_grouped, aes(x = reorder(job_category, salary_in_usd, FUN = median), 
                       y = salary_in_usd, 
                       fill = job_category)) +
  geom_boxplot() +
  coord_flip() + # Inverte gli assi per una lettura più chiara
  theme_minimal() +
  theme(legend.position = "none") + # Rimuove la legenda ridondante
  labs(
    title = "Confronto Retributivo per Macro-Categoria di Ruolo",
    x = "Categoria Professionale",
    y = "Stipendio (USD)"
  )



# Modello ANOVA
modello_anova <- aov(salary_in_usd ~ job_category, data = df_grouped)

# Tabella dei risultati ANOVA
summary(modello_anova)

# 1. Calcolo dei confronti a coppie
tukey_risultati <- TukeyHSD(modello_anova)

# 2. Stampa della tabella dei confronti
print(tukey_risultati)


# 3. Grafico degli intervalli di confidenza delle differenze medie
par(mar = c(5, 12, 4, 2)) # Aumenta il margine sinistro per leggere le etichette
plot(tukey_risultati, las = 1, col = "darkblue")



#Il test post-hoc di Tukey HSD rivela che la varianza evidenziata dall'ANOVA è interamente guidata
#dalla categoria Data Analyst, la quale presenta una retribuzione significativamente inferiore
#($\approx -32.000$ USD, $p < 0.001$) rispetto a tutti gli altri profili.
#Al contrario, tra Data Scientist, Data Engineer e ML Engineer non si registrano differenze salariali 
#statisticamente rilevanti ($p > 0.05$).