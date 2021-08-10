library("ggplot2")
library("sf")
library("rnaturalearth")
library("rnaturalearthdata")
library("rgeos")
library("dplyr")
library("ggspatial")

world <- ne_countries(scale = "medium", returnclass = "sf")
world_chuv_all <- world %>% mutate(Genomes =
                                     case_when(geounit == "China" ~ 48,
                                               geounit == "Brazil" ~ 12,
                                               geounit == "Austria" ~ 1,
                                               geounit == "United States of America" ~ 16,
                                               geounit == "United Kingdom" ~ 1,
                                               geounit == "Thailand" ~ 2,
                                               geounit == "France" ~ 2,
                                               geounit == "Venezuela" ~ 1,
                                               geounit == "Saudi Arabia" ~ 1,
                                               geounit == "Guadeloupe" ~ 2,
                                               geounit == "Germany" ~ 10,
                                               geounit == "South Africa" ~ 1,
                                               geounit == "South Korea" ~ 1,
                                               geounit == "Japan" ~ 3,
                                               geounit == "Finland" ~ 1,
                                               geounit == "Australia" ~ 3))


theme_set(theme_linedraw())

ggplot(data = world_chuv_all) +
  geom_sf(aes(fill = Genomes)) +
  xlab("Longitude") + ylab("Latitude") +
  annotation_north_arrow(location = "bl", which_north = "true", 
                         pad_x = unit(0.75, "in"), pad_y = unit(0.5, "in"),
                         style = north_arrow_fancy_orienteering) +
  coord_sf(expand = FALSE) + 
  scale_fill_viridis_c(option = "plasma")


