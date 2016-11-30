$(function(){

$('img.formulaInl').each(function(){
  embed(this, false);
})

$('img.formulaDsp').each(function(){
  embed(this, true);
})

function embed(el, standalone)
{
  var skip = standalone ? 2 : 1;
  var formula = el.alt.substring(skip);
  formula = formula.substring(0, formula.length - skip);
  formula = katex.renderToString(formula, {displayMode: standalone});
  console.log(standalone, formula);
  $(el).wrap('<span>').parent().html(formula);
}

});