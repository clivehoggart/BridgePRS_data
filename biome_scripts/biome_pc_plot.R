library(data.table)

pcs <- fread('/sc/private/regen/data/GSA_GDA/imputed_TOPMED_intermediate/addition/PC/GSA_GDA_PCA_intermediate.txt')
ancestry <- fread('~/biome/New_Ancestry_Sema4.csv')

png('~/biome_pc.png',width=1000,height=1000)
plot(pcs$PC1,pcs$PC2)
dev.off()
