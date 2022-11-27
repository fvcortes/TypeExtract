#---------------------------------------------------------------------#
# Create filter function
# l is the width of window
#---------------------------------------------------------------------#
meanfilter <- function( l, imagem ) {
  if( l%%2 == 0 )
    print("Please, type an odd number!")
  imagem.result <- imagem
  lp1d2 <- (l-1)/2
  L <- dim(imagem)[1]
  C <- dim(imagem)[2]
  for( j in as.integer(lp1d2+1) : as.integer(C-lp1d2)) {
    for( i in as.integer(lp1d2+1) : as.integer(L-lp1d2)) {
      imagem.result[i,j] <- mean(imagem[as.integer(i-lp1d2):as.integer(i+lp1d2), as.integer(j-lp1d2):as.integer(j+lp1d2)])
    }
  }
  print("Image filtred with success!")
  return(imagem.result)
}
#---------------------------------------------------------------------#
# End of Script.
#---------------------------------------------------------------------#