#this file compare a-b for Scarus vs others
library(here)
source(here("R", "00-load-libraries.R"))


fish.attributes <- fread(here("sample-data", 
                              "api.admin-fishspecies-export_2019-02-07_14-59-38.csv")) %>% 
  clean_names() %>% 
  as_tibble()

#fish file from API
fish.attributes
names(fish.attributes)

fish.coef <- fish.attributes %>% 
  rename(species = "fishattribute_ptr") %>% 
  dplyr::select(genus, species, 
                biomass_constant_a,
                biomass_constant_b,
                biomass_constant_c,
                maximum_length_cm, 
                trophic_level, 
                trophic_group, 
                functional_group)

fish.coef

#check Scarus coefficients
scarus <- fish.coef %>% 
  filter(genus == "Scarus")

scarus$species

#what are the average coefficients used for Scarus? 
scarus_avg <- scarus %>% 
  group_by(genus) %>% 
  summarize(mean_a = mean(biomass_constant_a), 
            mean_b = mean(biomass_constant_b))
scarus_avg

#setup a dataframe to compare MERMAID a-b to Sukmar a-b for fish 0-25cm 
size_min <- 5;
size_max <- 25;
N_x <- 50; #number of values in the x covariate
x <- seq(size_min,size_max,length.out=N_x)
x

test_data <- data.frame(x) %>% 
  as_tibble() %>% 
  rename("test_length_cm" = x) %>% 
  mutate(mermaid_a = scarus_avg$mean_a,
         mermaid_b = scarus_avg$mean_b, 
         kulbicki_a = 0.0239, 
         kulbicki_b = 2.956, 
         mermaid_biomass = mermaid_a * (test_length_cm^mermaid_b), 
         kulbicki_biomass = kulbicki_a * (test_length_cm^kulbicki_b))
  
  
test_data
ggplot(test_data, aes(x = kulbicki_biomass, y = mermaid_biomass)) +
  geom_point(shape = 21, size = 3) + 
  theme_sleek()

summary(lm(test_data$mermaid_biomass ~ test_data$kulbicki_biomass))

