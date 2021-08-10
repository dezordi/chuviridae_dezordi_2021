library(dendextend)
library(ape)
library(phytools)
packageVersion("dendextend")
##RDRP X GLY

tree1 <- read.tree(file = "./files/rdrp.nwk", text = NULL, tree.names = NULL, skip = 0, comment.char = "#", keep.multi = FALSE)
tree2 <- read.tree(file = "./files/glyco.nwk", text = NULL, tree.names = NULL, skip = 0, comment.char = "#", keep.multi = FALSE)

is.rooted(tree1)
is.rooted(tree2)

tree1 <- midpoint.root(tree1)
tree2 <- midpoint.root(tree2)

is.rooted(tree1)
is.rooted(tree2)

den1 <-chronos(tree1)
den2 <-chronos(tree2)

# common_subtrees_color_branches = . Color the branches of both dends based on the common subtrees. 
tanglegram(den1,den2,sort = FALSE, common_subtrees_color_lines = TRUE, 
           common_subtrees_color_branches = TRUE,highlight_distinct_edges = TRUE, 
           highlight_branches_lwd = FALSE,  lwd = 2,columns_width = c(3,1,3), 
           margin_inner = 19,rank_branches = TRUE,main_left = 'RdRp',main_right = 'Glyco',edge.lwd=2)

dev.off()

##RDRP X NUCL

tree1 <- read.tree(file = "./files/rdrp.nwk", text = NULL, tree.names = NULL, skip = 0, comment.char = "#", keep.multi = FALSE)
tree2 <- read.tree(file = "./files/nuc.nwk", text = NULL, tree.names = NULL, skip = 0, comment.char = "#", keep.multi = FALSE)

is.rooted(tree1)
is.rooted(tree2)

tree1 <- midpoint.root(tree1)
tree2 <- midpoint.root(tree2)

is.rooted(tree1)
is.rooted(tree2)

den1 <-chronos(tree1)
den2 <-chronos(tree2)

# common_subtrees_color_branches = . Color the branches of both dends based on the common subtrees. 
tanglegram(den1,den2,sort = FALSE, common_subtrees_color_lines = TRUE, 
           common_subtrees_color_branches = TRUE,highlight_distinct_edges = TRUE, 
           highlight_branches_lwd = FALSE,  lwd = 2,columns_width = c(3,1,3), 
           margin_inner = 19,rank_branches = TRUE,main_left = 'RdRp',main_right = 'Nucl',edge.lwd=2)

dev.off()

##GLY X NUCL

tree1 <- read.tree(file = "./files/glyco.nwk", text = NULL, tree.names = NULL, skip = 0, comment.char = "#", keep.multi = FALSE)
tree2 <- read.tree(file = "./files/nuc.nwk", text = NULL, tree.names = NULL, skip = 0, comment.char = "#", keep.multi = FALSE)

is.rooted(tree1)
is.rooted(tree2)

tree1 <- midpoint.root(tree1)
tree2 <- midpoint.root(tree2)

is.rooted(tree1)
is.rooted(tree2)

den1 <-chronos(tree1)
den2 <-chronos(tree2)

# common_subtrees_color_branches = . Color the branches of both dends based on the common subtrees. 
tanglegram(den1,den2,sort = FALSE, common_subtrees_color_lines = TRUE, 
           common_subtrees_color_branches = TRUE,highlight_distinct_edges = TRUE, 
           highlight_branches_lwd = FALSE,  lwd = 2,columns_width = c(3,1,3), 
           margin_inner = 19,rank_branches = TRUE,main_left = 'Glyco',main_right = 'Nucl',edge.lwd=2)

dev.off()
