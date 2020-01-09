// !preview r2d3 data=c(m_Dem_len, f_Dem_len, m_Rep_len, f_Rep_len)
//
// r2d3: https://rstudio.github.io/r2d3
//

var mycolor = ['orange', 'steelblue'];
    label = ['M', 'F', 'Democrat', 'Republican'];
svg.selectAll('rect')
    .style("500px", "400px")
    .data(data)
    .enter()
      .append('rect')
        .attr('x',  function(d, i) { 
          if(i === 0 || i == 1){
            return  100;
            }
          else{                       
            return 300}
          }
        )
        .attr('y',  function(d, i) { 
          if(i === 0 || i == 2)
            return 0;
          else if (i == 1)
            return data[0];
          else 
            return data[2];
        }
        )
        .attr('width', '190px' )
        .attr('height', function(d, i) {
            return d  ;
          }
        )
        .attr('fill', function(d, i){
          if(i === 0 || i == 2)
            return mycolor[0];
          else
            return mycolor[1];
          }
        );

texts = svg.selectAll('.myText')
            .data(data)
            .enter()
            .append('text');

texts.attr('x', function(d, i) {
        if(i === 0 || i == 1){
          return 70 ;
          }
        else if(i == 2){
          return 125;
          }
        else 
          return 350;
            }
          )
     .attr('y', function(d, i) {
        if(i === 0){
          return data[0]/2;
        }
        else if(i == 1){
          return data[0] + data[1] / 2;
        }
        else 
          return 400;
        }
      )
     .text(function(d,i) {return label[i]});

