// Some definitions presupposed by pandoc's typst output.
#let blockquote(body) = [
  #set text( size: 0.92em )
  #block(inset: (left: 1.5em, top: 0.2em, bottom: 0.2em))[#body]
]

#let horizontalrule = [
  #line(start: (25%,0%), end: (75%,0%))
]

#let endnote(num, contents) = [
  #stack(dir: ltr, spacing: 3pt, super[#num], contents)
]

#show terms: it => {
  it.children
    .map(child => [
      #strong[#child.term]
      #block(inset: (left: 1.5em, top: -0.4em))[#child.description]
      ])
    .join()
}

// Some quarto-specific definitions.

#show raw.where(block: true): set block(
    fill: luma(230),
    width: 100%,
    inset: 8pt,
    radius: 2pt
  )

#let block_with_new_content(old_block, new_content) = {
  let d = (:)
  let fields = old_block.fields()
  fields.remove("body")
  if fields.at("below", default: none) != none {
    // TODO: this is a hack because below is a "synthesized element"
    // according to the experts in the typst discord...
    fields.below = fields.below.amount
  }
  return block.with(..fields)(new_content)
}

#let unescape-eval(str) = {
  return eval(str.replace("\\", ""))
}

#let empty(v) = {
  if type(v) == "string" {
    // two dollar signs here because we're technically inside
    // a Pandoc template :grimace:
    v.matches(regex("^\\s*$")).at(0, default: none) != none
  } else if type(v) == "content" {
    if v.at("text", default: none) != none {
      return empty(v.text)
    }
    for child in v.at("children", default: ()) {
      if not empty(child) {
        return false
      }
    }
    return true
  }

}

// Subfloats
// This is a technique that we adapted from https://github.com/tingerrr/subpar/
#let quartosubfloatcounter = counter("quartosubfloatcounter")

#let quarto_super(
  kind: str,
  caption: none,
  label: none,
  supplement: str,
  position: none,
  subrefnumbering: "1a",
  subcapnumbering: "(a)",
  body,
) = {
  context {
    let figcounter = counter(figure.where(kind: kind))
    let n-super = figcounter.get().first() + 1
    set figure.caption(position: position)
    [#figure(
      kind: kind,
      supplement: supplement,
      caption: caption,
      {
        show figure.where(kind: kind): set figure(numbering: _ => numbering(subrefnumbering, n-super, quartosubfloatcounter.get().first() + 1))
        show figure.where(kind: kind): set figure.caption(position: position)

        show figure: it => {
          let num = numbering(subcapnumbering, n-super, quartosubfloatcounter.get().first() + 1)
          show figure.caption: it => {
            num.slice(2) // I don't understand why the numbering contains output that it really shouldn't, but this fixes it shrug?
            [ ]
            it.body
          }

          quartosubfloatcounter.step()
          it
          counter(figure.where(kind: it.kind)).update(n => n - 1)
        }

        quartosubfloatcounter.update(0)
        body
      }
    )#label]
  }
}

// callout rendering
// this is a figure show rule because callouts are crossreferenceable
#show figure: it => {
  if type(it.kind) != "string" {
    return it
  }
  let kind_match = it.kind.matches(regex("^quarto-callout-(.*)")).at(0, default: none)
  if kind_match == none {
    return it
  }
  let kind = kind_match.captures.at(0, default: "other")
  kind = upper(kind.first()) + kind.slice(1)
  // now we pull apart the callout and reassemble it with the crossref name and counter

  // when we cleanup pandoc's emitted code to avoid spaces this will have to change
  let old_callout = it.body.children.at(1).body.children.at(1)
  let old_title_block = old_callout.body.children.at(0)
  let old_title = old_title_block.body.body.children.at(2)

  // TODO use custom separator if available
  let new_title = if empty(old_title) {
    [#kind #it.counter.display()]
  } else {
    [#kind #it.counter.display(): #old_title]
  }

  let new_title_block = block_with_new_content(
    old_title_block, 
    block_with_new_content(
      old_title_block.body, 
      old_title_block.body.body.children.at(0) +
      old_title_block.body.body.children.at(1) +
      new_title))

  block_with_new_content(old_callout,
    block(below: 0pt, new_title_block) +
    old_callout.body.children.at(1))
}

// 2023-10-09: #fa-icon("fa-info") is not working, so we'll eval "#fa-info()" instead
#let callout(body: [], title: "Callout", background_color: rgb("#dddddd"), icon: none, icon_color: black) = {
  block(
    breakable: false, 
    fill: background_color, 
    stroke: (paint: icon_color, thickness: 0.5pt, cap: "round"), 
    width: 100%, 
    radius: 2pt,
    block(
      inset: 1pt,
      width: 100%, 
      below: 0pt, 
      block(
        fill: background_color, 
        width: 100%, 
        inset: 8pt)[#text(icon_color, weight: 900)[#icon] #title]) +
      if(body != []){
        block(
          inset: 1pt, 
          width: 100%, 
          block(fill: white, width: 100%, inset: 8pt, body))
      }
    )
}

//#assert(sys.version.at(1) >= 11 or sys.version.at(0) > 0, message: "This template requires Typst Version 0.11.0 or higher. The version of Quarto you are using uses Typst version is " + str(sys.version.at(0)) + "." + str(sys.version.at(1)) + "." + str(sys.version.at(2)) + ". You will need to upgrade to Quarto 1.5 or higher to use apaquarto-typst.")

// counts how many appendixes there are
#let appendixcounter = counter("appendix")
// make latex logo
// https://github.com/typst/typst/discussions/1732#discussioncomment-6566999
#let TeX = style(styles => {
  set text(font: ("New Computer Modern", "Times", "Times New Roman"))
  let e = measure("E", styles)
  let T = "T"
  let E = text(1em, baseline: e.height * 0.31, "E")
  let X = "X"
  box(T + h(-0.15em) + E + h(-0.125em) + X)
})
#let LaTeX = style(styles => {
  set text(font: ("New Computer Modern", "Times", "Times New Roman"))
  let a-size = 0.66em
  let l = measure("L", styles)
  let a = measure(text(a-size, "A"), styles)
  let L = "L"
  let A = box(scale(x: 105%, text(a-size, baseline: a.height - l.height, "A")))
  box(L + h(-a.width * 0.67) + A + h(-a.width * 0.25) + TeX)
})

#let firstlineindent=0.5in

// documentmode: man
#let man(
  title: none,
  runninghead: none,
  margin: (x: 1in, y: 1in),
  paper: "us-letter",
  font: ("Times", "Times New Roman"),
  fontsize: 12pt,
  leading: 18pt,
  spacing: 18pt,
  firstlineindent: 0.5in,
  toc: true,
  lang: "en",
  cols: 1,
  doc,
) = {

  set page(
    paper: paper,
    margin: margin,
    header-ascent: 50%,
    header: grid(
      columns: (9fr, 1fr),
      align(left)[#upper[#runninghead]],
      align(right)[#counter(page).display()]
    )
  )
  set bibliography(
    style: "apa.csl",
    title: "Referencias",
    full: true
  )

if sys.version.at(1) >= 11 or sys.version.at(0) > 0 {
  set table(    
    stroke: (x, y) => (
        top: if y <= 1 { 0.5pt } else { 0pt },
        bottom: .5pt,
      )
  )
}
  set par(
    justify: false, 
    leading: leading,
    first-line-indent: firstlineindent
  )

  // Also "leading" space between paragraphs
  set block(spacing: spacing, above: spacing, below: spacing)

  set text(
    font: font,
    size: fontsize,
    lang: lang
  )

  show link: set text(blue)

  show quote: set pad(x: 0.5in)
  show quote: set par(leading: leading)
  show quote: set block(spacing: spacing, above: spacing, below: spacing)
  // show LaTeX
  show "TeX": TeX
  show "LaTeX": LaTeX

  // format figure captions
  show figure.where(kind: "quarto-float-fig"): it => [
    #if int(appendixcounter.display().at(0)) > 0 [
      #heading(level: 2)[#it.supplement #appendixcounter.display("A")#it.counter.display()]
    ] else [
      #heading(level: 2)[#it.supplement #it.counter.display()]
    ]
    #par[#emph[#it.caption.body]]
    #align(center)[#it.body]
  ]
  
  // format table captions
  show figure.where(kind: "quarto-float-tbl"): it => [
    #if int(appendixcounter.display().at(0)) > 0 [
      #heading(level: 2)[#it.supplement #appendixcounter.display("A")#it.counter.display()]
    ] else [
      #heading(level: 2)[#it.supplement #it.counter.display()]
    ]
    #par[#emph[#it.caption.body]]
    #block[#it.body]
  ]

 // Redefine headings up to level 5 
  show heading.where(
    level: 1
  ): it => block(width: 100%, below: leading, above: leading)[
    #set align(center)
    #set text(size: fontsize)
    #it.body
  ]
  
  show heading.where(
    level: 2
  ): it => block(width: 100%, below: leading, above: leading)[
    #set align(left)
    #set text(size: fontsize)
    #it.body
  ]
  
  show heading.where(
    level: 3
  ): it => block(width: 100%, below: leading, above: leading)[
    #set align(left)
    #set text(size: fontsize, style: "italic")
    #it.body
  ]

  show heading.where(
    level: 4
  ): it => text(
    size: 1em,
    weight: "bold",
    it.body
  )

  show heading.where(
    level: 5
  ): it => text(
    size: 1em,
    weight: "bold",
    style: "italic",
    it.body
  )

  if cols == 1 {
    doc
  } else {
    columns(cols, gutter: 4%, doc)
  }

}

#show: document => man(
  runninghead: "Short Paper",
  lang: "es",
  document,
)

\
\
#block[
#heading(
level: 
1
, 
numbering: 
none
, 
outlined: 
false
, 
[
Short Paper: A Short Subtitle
]
)
]
#set align(center)
#block[
\
Ian Contreras

Economía y Negocios, Instituto Tecnológico de Santo Domingo

]
#set align(left)
#block[
#heading(
level: 
1
, 
numbering: 
none
, 
outlined: 
false
, 
[
Author Note
]
)
]
#pagebreak()

#block[
#heading(
level: 
1
, 
numbering: 
none
, 
outlined: 
false
, 
[
Resumen
]
)
]
#block[
]
#par()[#text(size:0.5em)[#h(0.0em)]]
#v(-18pt)
#emph[Palabras clave];: keyword1, keyword2

#pagebreak()

#block[
#heading(
level: 
1
, 
numbering: 
none
, 
outlined: 
false
, 
[
Short Paper: A Short Subtitle
]
)
]
= Introducción
<introducción>
== Planteamiento del Problema
<planteamiento-del-problema>
#par()[#text(size:0.5em)[#h(0.0em)]]
#v(-18pt)
La coexistencia de dos emisores de deuda gubernamental se ha convertido en uno de los puntos más cuestionados en la economía dominicana de la última década. La principal crítica radica en que el Banco Central realiza una gestión ineficiente de su deuda, reflejada en la evolución negativa de su patrimonio. No obstante, dado que el Banco Central opera bajo un régimen de flotación sucia, en el cual la emisión de deuda funciona como herramienta de control de liquidez (quantitative tightening), resulta inapropiado evaluar su manejo de pasivos desde una óptica meramente contable.

El origen de esta dualidad en la emisión de deuda pública se remonta a la crisis financiera de 2003-2004, cuando el colapso de tres importantes instituciones bancarias (Baninter, Bancrédito y Banco Mercantil) provocó una intervención masiva del Banco Central para evitar un riesgo sistémico. El rescate bancario, que representó aproximadamente el 20.3% del PIB, resultó en una emisión de RD\$109,150 millones en instrumentos de deuda por parte del Banco Central. Esta intervención, si bien necesaria para mantener la estabilidad del sistema financiero, generó un deterioro significativo en el balance del banco central y dio origen a un déficit cuasifiscal que persiste hasta la actualidad, condicionando tanto el manejo de la política monetaria como fiscal. (#link(<ref-oecd_mercado_2012>)[OECD, 2012];)

La problemática actual presenta cuatro dimensiones críticas interrelacionadas. En primer lugar, existen desafíos significativos en la coordinación de las políticas monetaria y fiscal en un contexto de vulnerabilidad de la balanza de pagos. República Dominicana, como importador neto de commodities, enfrenta limitaciones estructurales para contrarrestar los choques externos en los precios de importación, lo que genera presiones recurrentes sobre el tipo de cambio y condiciona la efectividad de la política monetaria. Esta situación se refleja en un déficit persistente en cuenta corriente, que ha alcanzado niveles cercanos al 8% del PIB en años recientes.

En segundo lugar, la competencia entre el Banco Central y el Ministerio de Hacienda en el mercado de deuda pública ha resultado en un aumento de los costos de financiamiento, particularmente en el tramo medio de la curva de tasas de interés. La falta de coordinación entre ambas instituciones se manifiesta en diferenciales significativos de tasas para instrumentos de similar vencimiento, llegando a superar los 350 puntos base en algunos casos. Esta divergencia en las tasas de colocación refleja objetivos institucionales distintos: mientras el Ministerio de Hacienda busca minimizar el costo del financiamiento público, el Banco Central utiliza la emisión de deuda como instrumento de política monetaria para controlar la liquidez y estabilizar el tipo de cambio. (#link(<ref-oecd_mercado_2012>)[OECD, 2012];)

El tercer aspecto crítico concierne a la evolución del déficit cuasifiscal y sus implicaciones para las expectativas inflacionarias en el marco de la curva de Phillips. La acumulación de pérdidas operativas del Banco Central, que se ha intensificado desde la crisis de 2003-2004, genera preocupaciones sobre la sostenibilidad de largo plazo de este esquema de política monetaria. La literatura empírica sugiere que los déficits cuasifiscales significativos pueden eventualmente resultar en presiones inflacionarias, sea a través de la monetización directa del déficit o mediante el deterioro de las expectativas de los agentes económicos. (#link(<ref-cruz-rodriguez_deficit_2006>)[Cruz-Rodríguez, 2006];)

Un cuarto elemento crítico radica en las limitaciones constitucionales que enfrenta el Banco Central para financiar al gobierno central en el mercado de bonos. Esta restricción, que solo puede ser levantada en circunstancias excepcionales y bajo condiciones estrictas, reduce significativamente los instrumentos disponibles para el control de la depreciación del tipo de cambio.

El debate sobre la reforma de este esquema institucional ha generado dos posiciones principales. Por un lado, algunos economistas, abogan por la consolidación de la deuda gubernamental bajo el Ministerio de Hacienda, argumentando que la gestión actual ha sido ineficiente y ha resultado en un crecimiento significativo de la deuda del Banco Central, que actualmente representa aproximadamente el 15% del PIB. Esta posición sugiere que la centralización del manejo de la deuda en un solo emisor soberano permitiría mejorar las condiciones de emisión y reducir los costos de financiamiento.

La posición contraria sostiene que, dada la diferente naturaleza de las funciones de reacción de ambas instituciones, la unificación de la emisión de deuda podría ser contraproducente para el logro de sus respectivos objetivos. Además, argumentan que el Banco Central perdería su instrumento más efectivo para controlar las presiones sobre el tipo de cambio, lo cual podría comprometer la estabilidad macroeconómica en un contexto de alta vulnerabilidad externa.

La determinación del régimen óptimo de coordinación económica representa uno de los mayores desafíos de política económica que enfrenta la República Dominicana actualmente. Esta problemática presenta dos dimensiones fundamentales: por un lado, la necesidad de establecer mecanismos efectivos de coordinación entre las autoridades monetarias y financieras, y por otro, la identificación de los instrumentos más adecuados para alcanzar los objetivos de política. La complejidad de este reto radica en la necesidad de adoptar una perspectiva multidimensional que considere los diferentes equilibrios económicos implicados. El mecanismo actual de control de liquidez presenta un dilema fundamental: ¿es preferible mantener una política con mayor costo económico que ha demostrado efectividad en el control de las expectativas cambiarias, o este enfoque representa un riesgo insostenible para las finanzas del Banco Central en el largo plazo? La resolución de esta disyuntiva requiere la consideración de múltiples factores, incluyendo la prima de riesgo por intervención de liquidez, la competencia en los tramos corto y medio de la curva de intereses, y las implicaciones de la "aritmética monetarista desagradable". Como resultado, la búsqueda de un marco institucional óptimo que balancee estos diferentes objetivos y restricciones se mantiene como una pregunta abierta en el diseño de la política económica dominicana.

== Propósito de la Investigación
<propósito-de-la-investigación>
#par()[#text(size:0.5em)[#h(0.0em)]]
#v(-18pt)
Este estudio contribuye a la literatura de política económica mediante el análisis de los regímenes de coordinación óptimos entre la política monetaria y fiscal en la República Dominicana, empleando un marco teórico de juegos para una economía pequeña y abierta. La investigación desarrolla un modelo de equilibrio general dinámico y estocástico (DSGE) que incorpora las características fundamentales de la economía dominicana, incluyendo una restricción intertemporal consolidada para las instituciones gubernamentales y un mecanismo de transmisión del tipo de cambio a la inflación. Este enfoque permite examinar las interacciones estratégicas entre las autoridades monetarias y fiscales bajo diferentes escenarios de coordinación, contribuyendo así a la comprensión de las implicaciones del déficit cuasifiscal del Banco Central.

La metodología propuesta se distingue por tres aspectos innovadores. Primero, desarrolla un análisis basado en teoría de juegos del esquema líder-seguidor entre las políticas monetaria y fiscal, específicamente adaptado para una economía pequeña y abierta como la dominicana. Segundo, implementa un conjunto de experimentos contrafactuales utilizando parámetros estructurales del período 2012-2024, que permitirán evaluar diferentes regímenes de coordinación y sus implicaciones para el bienestar social. Tercero, incorpora un análisis de sensibilidad global que examina la robustez de los resultados ante variaciones en los parámetros estructurales del modelo, proporcionando así una evaluación comprehensiva de la estabilidad y unicidad de los equilibrios encontrados. Esta aproximación metodológica permite identificar el régimen de coordinación que minimiza las pérdidas sociales, ofreciendo recomendaciones de política económica basadas en evidencia cuantitativa.

== Preguntas de Investigación
<preguntas-de-investigación>
+ ¿Cuál es el esquema óptimo de coordinación de políticas fiscales y monetarias en el contexto de la economía dominicana?

+ ¿Cuál es el dominio de los parámetros estructurales de forma que se asegura la estabilidad del regimen de coordinación óptimo?

+ ¿Qué reformas y/o instrumentos alternativos podrían ser necesarios para alcanzar el esquema de coordinación óptimo previamente definido?

#pagebreak()
= Revisión Literaria
<revisión-literaria>
== Marco teórico
<marco-teórico>
#par()[#text(size:0.5em)[#h(0.0em)]]
#v(-18pt)
El análisis de la política monetaria se ha centrado históricamente en responder dos preguntas fundamentales: los impactos de una regla de política monetaria sobre la economía y la regla de política monetaria óptima bajo ciertas condiciones. Esta segunda interrogante ha cobrado especial relevancia en el contexto de las reglas de la adopción de los esquemas de metas explícitas de inflación.

La discusión sobre reglas versus discrecionalidad en política monetaria tiene sus raíces en los trabajos seminales de (#link(<ref-kydland_rules_1977>)[Kydland & Prescott, 1977];) y (#link(<ref-barro_rules_1983>)[Barro & Gordon, 1983];), quienes demostraron que la extrema flexibilidad o discrecionalidad en el manejo monetario conduce a una pérdida de credibilidad, afectando directamente el objetivo de estabilización y generando un "sesgo inflacionario". Este hallazgo fundamental llevó al desarrollo de un marco analítico basado en reglas monetarias que pudieran servir como guía para las intervenciones de los bancos centrales.

(#link(<ref-taylor_discretion_1993>)[Taylor, 1993];) marcó un hito en esta literatura al proponer una regla simple que relaciona la tasa de interés nominal con las desviaciones de la inflación respecto a su nivel objetivo y las desviaciones del producto respecto a su nivel potencial. Su trabajo demostró que las políticas monetarias centradas en estos objetivos son más eficientes que aquellas que se ajustan con la oferta de dinero y el tipo de cambio. (#link(<ref-svensson_inflation_1997>)[Svensson, 1997];) y (#link(<ref-clarida_science_1999>)[Clarida et~al., 1999];) posteriormente formalizaron los fundamentos teóricos de la regla de Taylor y propusieron diversas modificaciones sobre esta base de referencia.

La interacción entre políticas monetaria y fiscal introduce una dimensión adicional al análisis. (#link(<ref-nordhaus_policy_1994>)[Nordhaus, 1994];) examinó esta interacción desde un marco de teoría de juegos, encontrando que la falta de coordinación entre autoridades puede resultar en equilibrios subóptimos caracterizados por altas tasas de interés y déficits presupuestarios. (#link(<ref-van_aarle_monetary_1995>)[Aarle et~al., 1995];) profundizaron este análisis en el contexto de la estabilización de la deuda, mientras que estudiaron la necesidad de ajuste de la política monetaria para mantener baja inflación en el marco de distintas estructuras de coordinación entre hacedores de política.

El desarrollo de modelos de equilibrio general dinámico y estocástico (DSGE) ha proporcionado un marco más riguroso para analizar estas interacciones. El modelo seminal de (#link(<ref-gali_monetary_2005>)[Galí & Monacelli, 2005];) para economías pequeñas y abiertas incorpora rigideces nominales y competencia monopolística en un marco de optimización intertemporal. La estructura del modelo incluye hogares que maximizan su utilidad, empresas que operan en un entorno de competencia monopolística con precios rígidos siguiendo el esquema de (#link(<ref-calvo_staggered_1983>)[Calvo, 1983];), y autoridades monetarias y fiscales que implementan políticas económicas.

Este marco teórico permite analizar la transmisión de la política monetaria a través de varios canales. La rigidez de precios de Calvo genera efectos reales de la política monetaria y captura la persistencia observada en la inflación. La apertura de la economía se modela mediante un índice de precios al consumidor que incluye tanto bienes domésticos como importados, con un mecanismo de pass-through del tipo de cambio a la inflación, aspecto crucial para economías pequeñas y abiertas.

La literatura más reciente, ejemplificada por trabajos como (#link(<ref-bartolomeo_fiscal-monetary_2005>)[Bartolomeo & Gioacchino, 2005];), ha integrado la teoría de juegos en este marco DSGE para analizar las interacciones estratégicas entre autoridades monetarias y fiscales. Este enfoque permite examinar diferentes escenarios de coordinación, desde equilibrios Nash simultáneos hasta soluciones Stackelberg con distintos ordenamientos de liderazgo, proporcionando insights sobre los regímenes de coordinación óptimos para diferentes estructuras económicas.

== Antecedentes
<antecedentes>
#par()[#text(size:0.5em)[#h(0.0em)]]
#v(-18pt)
La literatura sobre coordinación de políticas económicas en la República Dominicana presenta un vacío significativo en cuanto al análisis de interacciones estratégicas entre autoridades monetaria y fiscal mediante teoría de juegos en un contexto de modelos DSGE. El referente internacional más cercano a este tipo de análisis es el trabajo de (#link(<ref-tetik_evaluation_2021>)[Tetik & Ceylan, 2021];) para la economía turca, que comparte características similares como economía pequeña y abierta. Esta brecha en la literatura dominicana representa una oportunidad importante para expandir nuestra comprensión de los mecanismos de coordinación de políticas económicas en el país.

(#link(<ref-tetik_evaluation_2021>)[Tetik & Ceylan, 2021];) aplica teoría de juegos al análisis de la interacción entre autoridades monetaria y fiscal sobre el modelo neokeynesiano de Galí. Mediante experimentos contrafactuales con datos de la economía turca para 2006-2019, encuentra que el escenario que minimiza la pérdida social ocurre cuando la autoridad monetaria actúa como líder de Stackelberg. Sus resultados muestran patrones de respuesta específicos ante choques exógenos, que varían según la naturaleza del choque y la posición jerárquica de cada autoridad.

(#link(<ref-ramirez_modelo_2014>)[Ramírez & Torres, 2014];) realiza la primera publicación de una estimación de un modelo DSGE para la República Dominicana basado en el marco de (#link(<ref-gali_monetary_2005>)[Galí & Monacelli, 2005];). Su modelo incorpora fricciones nominales y persistencia en hábitos de consumo característicos de la economía dominicana. La estimación bayesiana de parámetros estructurales establece una base cuantitativa para el análisis de política monetaria en el país.

(#link(<ref-perez_perez_nueva_2021>)[Pérez Pérez, 2021];) determina reglas de política monetaria óptimas para la República Dominicana comparando especificaciones de curvas de reacción. Su investigación indica que una regla de política monetaria forward-looking que considera la inflación observada, la inflación proyectada y la inercia de la tasa de interés genera mejores resultados de bienestar social, con variaciones según los choques que afectan a la economía.

La presente investigación se construye sobre estos antecedentes de manera integral, combinando el marco metodológico de teoría de juegos desarrollado por Tetik con las estimaciones de parámetros estructurales de Ramírez y los hallazgos sobre reglas monetarias óptimas de Pérez. Esta síntesis permite desarrollar un marco analítico robusto que examina por primera vez las interacciones estratégicas entre autoridades monetaria y fiscal en la República Dominicana.

#pagebreak()
= Estructura del Modelo
<estructura-del-modelo>
== Un modelo DSGE neokeynesiano para la economía dominicana
<un-modelo-dsge-neokeynesiano-para-la-economía-dominicana>
#par()[#text(size:0.5em)[#h(0.0em)]]
#v(-18pt)
Basándonos en los precedentes planteados por (#link(<ref-ramirez_modelo_2014>)[Ramírez & Torres, 2014];) y (#link(<ref-perez_perez_nueva_2021>)[Pérez Pérez, 2021];), la economía dominicana se puede caracterizar de manera adecuada por un modelo de equilibrio general neokeynesiano de una economía pequeña y abierta que incorpora fricciones financieras en el mercado de bonos gubernamentales, planteado en (#link(<ref-gali_monetary_2015>)[Galí, 2015];). El modelo está habitado por cuatro agentes económicos principales que optimizan sus decisiones: los hogares, que enfrentan costos de ajuste de portafolio al distribuir sus recursos entre bonos de corto y largo plazo; las firmas domésticas que operan en competencia monopolística; los importadores; y el gobierno como autoridad de política fiscal y el Banco Central como la autoridad monetaria. La característica distintiva del modelo es la incorporación de rigideces nominales de precios tipo Calvo, impuestos distorsionadores, y un pass-through completo del tipo de cambio, donde la demanda agregada depende de un promedio ponderado de las tasas de interés de corto y largo plazo.

La estructura del modelo incorpora diversos canales de transmisión y fuentes de choques, donde la curva de Phillips caracteriza una oferta agregada con precios rígidos que no se ajustan instantáneamente a cambios en costos o demanda. El mecanismo de transmisión internacional opera a través del tipo de cambio nominal y la paridad descubierta de tasas de interés, permitiendo que los choques externos afecten a la economía doméstica. El modelo considera cinco fuentes principales de incertidumbre: choques de política monetaria, productividad, preferencias, tasa de interés internacional y nivel de precios mundial. La regla de política monetaria óptima se deriva de al comparar los equilibrios generales resultantes de las intereacciónes entre el Banco Central y el Ministerio de Hacienda en los distintos regímenes de coordinación.

=== Equilibrio en el mercado de dinero
<equilibrio-en-el-mercado-de-dinero>
#par()[#text(size:0.5em)[#h(0.0em)]]
#v(-18pt)
El equilibrio en el mercado de dinero se ve representado a través de la Curva de Phillips Neokeynesiana para una economía pequeña y abierta se representa de la siguiente manera:

#math.equation(block: true, numbering: "(1)", [ $ pi_(H , t) = beta E_t { pi_(H , t + 1) } + kappa tilde(y)_t - sigma_a tilde(g)_t $ ])<eq-cp-neokeynesiana>

En la @eq-cp-neokeynesiana, $pi_(H , t)$ representa la inflación doméstica, medida como la tasa de variación en el índice de precios de bienes domésticos (IPC). El término $E_t pi_(H , t + 1)$ denota las expectativas de inflación doméstica, mientras que $tilde(y)_t$ representa la brecha del producto doméstico. Esta última se define como la desviación logarítmica del producto doméstico $(y_t)$ respecto a su nivel natural $(y_t^N)$, expresada formalmente como $(tilde(y) equiv y_t - y_t^N)$. La variable $tilde(g)$ corresponde al déficit fiscal, calculado como la diferencia entre la variable de política fiscal $g_t$ y su valor óptimo en ausencia de rigideces nominales $(tilde(g) equiv g_t - g_t^N)$.

El parámetro $kappa$ representa la pendiente de la Curva de Phillips Neokeynesiana y captura la relación fundamental entre la inflación doméstica, las expectativas inflacionarias y la brecha del producto. Específicamente, $kappa$ revela cómo la dinámica inflacionaria está condicionada por el grado de apertura económica, $sigma_a$, y la elasticidad de sustitución entre bienes domésticos e importados.

=== Equilibrio en el mercado de bienes
<equilibrio-en-el-mercado-de-bienes>
#par()[#text(size:0.5em)[#h(0.0em)]]
#v(-18pt)
El equilibrio dinámico en el mercado de bienes en términos de brecha del producto se expresa como:

#math.equation(block: true, numbering: "(1)", [ $ hat(y)_t = E_t { hat(y)_(t + 1) } - 1 / sigma_a (r_t - E_t { pi_(H , t + 1) } - r^N) - E_t { Delta xi_(t + 1) } $ ])<eq-is>

La curva IS dinámica @eq-is está influenciada por una combinación de tasas de interés tanto de corto como de largo plazo, donde la tasa de interés real natural $r^N$ sirve como punto de referencia para evaluar la postura de la política monetaria. La autoridad monetaria tiene dos vías para influir en esta tasa. Dicha tasa queda descrita por la siguiente ecuación:

#math.equation(block: true, numbering: "(1)", [ $ partial_t^N = sigma_a (E_i { y_(i + 1)^N } - y_i^N) - alpha (omega - 1) (rho_(c^(\*)) - 1) c_t^(\*) = r_i^N = frac(sigma_a (1 + phi.alt) (rho_a - 1), sigma_a + phi.alt) a_i + frac(phi.alt alpha (omega - 1), sigma_a + phi.alt) (rho_c - 1) c_i^(\*) $ ])<eq-r-natural>

Donde $a_t$ es el nivel natural de productividad y $c_t^(\*)$ son los choques de producto exógenos, y se asumen que siguen un proceso autoregresivo de orden ARIMA(1,0,0). Por otro lado, asume que en el equilibrio de esta economía abierta con precios flexibles, no debe existir deficit o superávit gubernamental, osea que $g^(\*) - t^(\*) = 0$.

En primer lugar, puede utilizar ajustes en la tasa de interés nominal de corto plazo como herramienta para controlar las fluctuaciones del producto y mantener la inflación doméstica dentro de los límites establecidos. En segundo lugar, cuando los bonos no son perfectamente sustituibles entre sí, emerge un mecanismo adicional de transmisión de la política monetaria que puede afectar la demanda agregada, como sucede en el caso dominicano.

=== Restricción intertemporal del gobierno consolidado
<restricción-intertemporal-del-gobierno-consolidado>
#par()[#text(size:0.5em)[#h(0.0em)]]
#v(-18pt)
El presupuesto estatal está limitado por restricciones financieras específicas. Según (#link(<ref-friedman_government_1971>)[Friedman, 1971];), existe una equivalencia entre el gasto gubernamental y la carga impositiva total sobre los ciudadanos. Cuando los gastos estatales exceden la recaudación fiscal, el gobierno recurre a la emisión de deuda y/o al señoriaje para cubrir este déficit. Sin embargo, estas obligaciones financieras eventualmente deberán ser cubiertas mediante una mayor presión fiscal futura. Considerando que el gobierno central es el propietario último del Banco Central, la interacción entre las políticas monetarias y fiscales emerge principalmente de la restricción presupuestaria intertemporal del gobierno consolidado, ya que la deuda de ambas instituciones está fundamentalmente determinada por el valor presente de la recaudación fiscal.

La política fiscal, que puede causar un aumento en el déficit presupuestario actual, será financiada por un aumento en los ingresos fiscales futuros o el valor de las llamadas obligaciones gubernamentales nominales, como el dinero. Esto se conoce como "La Aritmética Monetarista Desagradable" de (#link(<ref-sargent_unpleasant_1981>)[Sargent & Wallace, 1981];). En nuestro caso, utilizaremos la versión log-linearizada de la restricción gubernamental planteada por (#link(<ref-fragetta_strategic_2010>)[Fragetta & Kirsanova, 2010];), que se expresa como:

#math.equation(block: true, numbering: "(1)", [ $ hat(b)_(t + 1) = (r_t - r_t^N) + 1 / beta (hat(b)_t - pi_(H , t) + C^(‾) / B^(‾) hat(g)_t + frac(1 - C^(‾) - tau, B^(‾)) hat(y)_t) $ ])<eq-aritmetica-desagradable>

En @eq-aritmetica-desagradable, $b_t = log (B_t / P_(H , t + 1))$ donde $B$ es el stock de deuda nominal. $B^(‾)$ y $C^(‾)$ representan la razón deuda/PIB en estado estacionario y la razón consumo/PIB en estado estacionario respectivamente. $tau$ es la tasa fija de impuesto sobre la renta.

#pagebreak()
== Juegos de política monetaria y fiscal
<juegos-de-política-monetaria-y-fiscal>
#par()[#text(size:0.5em)[#h(0.0em)]]
#v(-18pt)
En esta sección, analizaremos la interacción entre las autoridades monetarias y fiscales se analiza mediante modelos de teoría de juegos. Estos juegos involucran dos jugadores: el Banco Central como autoridad monetaria y el Ministerio de Hacienda como autoridad fiscal.Cada uno con sus propios instrumentos: la tasa de interés $r_t$ y el gasto gubernamental $g_t$ respectivamente. El juego entre las políticas monetarias y fiscales se fundamenta en la propensión de cada autoridad a minimizar su función de pérdida. La naturaleza de esta interacción puede ser no cooperativa, cuando actúan independientemente, o cooperativa, cuando coordinan sus acciones. Sin embargo, dicha interacción esta sujeta a los límites de la economía hipotética planteados mediante las ecuaciones @eq-is, @eq-cp-neokeynesiana y @eq-aritmetica-desagradable. Las reglas de política óptimas (estrategias) de los responsables de las políticas monetarias y fiscales se derivan con base en estas ecuaciones.

Las autoridades derivan funciones de reacción óptimas para diversos regímenes de coordinación, sujetas a las condiciones de equilibrio de la economía. Este proceso implica un compromiso con reglas óptimas que exhiben propiedades de consistencia temporal. El marco analítico implementa el enfoque general de política lineal-cuadrática introducido por (#link(<ref-giannoni_optimal_2003>)[Giannoni & Woodford, 2003];), que resuelve las optimizaciones mediante el enfoque de la técnica de Lagrange . La validez de esta metodología se fundamenta en tres aspectos cruciales: la consistencia con el equilibrio deseado bajo compromiso, la invariabilidad temporal de las reglas de política, y la preservación de la optimalidad independientemente de las perturbaciones exógenas que afecten a la economía. (#link(<ref-saulo_fiscal_2013>)[Saulo et~al., 2013];)

Para nuestros jugadores, sus la forma funcional de sus funciones de pérdida son una representación del objetivo de cada institución. De manera general, las funciones de pérdida penalizan la varianza de las variables de interés con respecto a sus valores de equilibrio o meta. Dichas funciones se expresan como:

=== Función de pérdidas del Banco Central
<función-de-pérdidas-del-banco-central>
#par()[#text(size:0.5em)[#h(0.0em)]]
#v(-18pt)
#math.equation(block: true, numbering: "(1)", [ $ L_t^M = gamma_pi V a r (pi_t) + gamma_y V a r (tilde(y)_t) + gamma_r V a r (r_t - r^(\*)) $ ])<eq-fp-bc>

Los parámetros $gamma$ representan la sensibilidad del Banco Central a la varianza de la respectiva variable. Estos son definidos positivos y se asume que $gamma_pi + gamma_y + gamma_r = 1$.

=== Función de pérdidas del Ministerio de Hacienda
<función-de-pérdidas-del-ministerio-de-hacienda>
#par()[#text(size:0.5em)[#h(0.0em)]]
#v(-18pt)
#math.equation(block: true, numbering: "(1)", [ $ L_t^F = rho_pi V a r (pi_t) + rho_y V a r (tilde(y)_t) + rho_g V a r (tilde(g)_t) $ ])<eq-fp-mh>

Los parámetros $rho$ representan la sensibilidad del Ministerio de Hacienda a la varianza de la respectiva variable. Estos son definidos positivos y se asume que $rho_pi + rho_y + rho_g = 1$.

=== Juego normal
<juego-normal>
#par()[#text(size:0.5em)[#h(0.0em)]]
#v(-18pt)
En el contexto donde los responsables de políticas monetarias y fiscales establecen sus instrumentos de manera simultánea y no cooperativa, se implementa un modelo de juego en forma normal. Cada uno con acciones disponibles específicas y funciones de utilidad que asignan valores reales a cada posible resultado. La solución más relevante en este contexto es el equilibrio de Nash, una situación en la cual ningún jugador puede mejorar su posición mediante desviaciones unilaterales de su estrategia de equilibrio.

==== Derivación de las curvas de reacción bajo un regimen de independencia total.
<derivación-de-las-curvas-de-reacción-bajo-un-regimen-de-independencia-total.>
El objetivo del Banco Central es resolver el siguiente problema de optimización: \_{}Var(#emph[\t) + ];{y}Var(#emph[\t) + ];{r}Var(r\_t - r^\*) #math.equation(block: true, numbering: "(1)", [ $ min_(r_t) E_0 (1 / 2 sum_(t = 0)^oo beta^t (L_t^M)) $ ])<eq-nash-bc-opt>

sujeto a @eq-is y @eq-cp-neokeynesiana

Este problema de optimización se puede expresar en su forma lagrangiana, que resulta en: $ L = E_0 [sum_(t = 0)^oo beta^t vec(1 / 2 gamma_pi V a r (pi_t) + 1 / 2 gamma_y V a r (tilde(y)_t) + 1 / 2 gamma_r V a r (r_t - r^(\*)), + Lambda_(1 , t) (tilde(y)_t - tilde(y)_(t + 1) + 1 / sigma_alpha ((r_t - r_t^N) - pi_(H , t + 1)) + g^(‾)_(t + 1) - g^(‾)_t), + Lambda_(2 , t) (pi_(H , t) - beta pi_(H , t + 1) - kappa tilde(y)_t + sigma_alpha g^(‾)_t - epsilon_t^pi))] $

#par()[#text(size:0.5em)[#h(0.0em)]]
#v(-18pt)
Para resolver el lagrangiano, hay que obtener las condiciones de primer orden al derivar el lagrangiano respecto a $(r_t - r^(\*))$, $tilde(y)_t$ y $pi_(H , t)$. Al resolver este sistema de ecuaciones partiendo de las condiciones de primer orden, y despejar la tasa de interés nominal, obtenemos la regla de política monetaria optima:

#math.equation(block: true, numbering: "(1)", [ $ r_t^(N C N) = Theta_(r , 1) r_(t - 1) - Theta_(r , 2) r_(t - 2) + Theta_(pi , r) pi_(H , t) + Theta_(1 , y) tilde(y)_t - Theta_(1 , y) tilde(y)_(t - 1) - Theta_r r^(\*) $ ])<eq-regla-optima-bc-ncn>

Donde los coeficientes $Theta_(r , i)$ se describen como: $ Theta_(r , 1) = (sigma_alpha kappa + beta + 1) / beta , Theta_(r , 2) = 1 / beta , Theta_(pi , r) = frac(gamma_pi kappa, gamma_r sigma_alpha) , Theta_(1 , y) = Theta_(y , n) = frac(gamma_y, gamma_r sigma_alpha) , upright(" and ") Theta_r = frac(sigma_alpha kappa, beta) $

Por el lado del Ministerio de Hacienda, su objetivo es resolver el siguiente problema de optimización:

#math.equation(block: true, numbering: "(1)", [ $ min_(g_t) E_0 (1 / 2 sum_(t = 0)^oo beta^t (L_t^F)) $ ])<eq-nash-mh-opt>

sujeto a @eq-is, @eq-cp-neokeynesiana y @eq-aritmetica-desagradable

Que en su forma lagrangiana, resulta en:

$ L = E_0 [sum_(t = 0)^oo beta^t vec(1 / 2 rho_pi V a r (pi_t) + 1 / 2 rho_y V a r (tilde(y)_t) + 1 / 2 rho_g V a r (tilde(g)_t), + Lambda_(1 , t) (tilde(y)_t - tilde(y)_(t + 1) + 1 / sigma_alpha ((r_t - r_t^N) - pi_(H , t + 1)) + g^(‾)_(t + 1) - g^(‾)_t), + Lambda_(2 , t) (pi_(H , t) - beta pi_(H , t + 1) - kappa tilde(y)_t + sigma_alpha g^(‾)_t - epsilon_t^pi), + Lambda_(3 , t) ((r_t - r_t^N) + 1 / beta (hat(b)_t - pi_(H , t) + C^(‾) / B^(‾) hat(g)_t + frac(1 - C^(‾) - tau, B^(‾)) hat(y)_t)))] $

Al resolver el lagrangiano y despejar para la regla de política fiscal óptima $tilde(g)_t^(N C N)$ obtenemos:

#math.equation(block: true, numbering: "(1)", [ $ tilde(g)_t^(N C N) = & - K + Psi_(g , + 1) E_t { tilde(g)_(t + 1) } + Psi_(g , 1) tilde(g)_(t - 1) + Psi_(y , + 1) E_t { tilde(y)_(t + 1) } - Psi_(y , 0) tilde(y)_t +\
 & + Psi_(y , 1) tilde(y)_(t - 1) - Psi_(pi , + 1) E_t { pi_(H , t + 1) } + Psi_(pi , 0) pi_(H , t) $ ])<eq-regla-optima-mh-ncn>

Donde los coeficientes $Psi_(g , j)$ se describen como:

$ Psi_(g , + 1) & = frac(beta sigma_a, D)\
Psi_(g , 1) & = sigma_a / D\
Psi_(y , + 1) & = frac(beta sigma_a rho_y, rho_g D)\
Psi_(y , 0) & = frac(rho_y sigma_a (beta + 2), rho_g D)\
Psi_(y , 1) & = frac(rho_y sigma_a, rho_g D)\
Psi_(pi , + 1) & = frac(beta sigma_a rho_pi (sigma_a - kappa), rho_g D)\
Psi_(pi , 0) & = frac(sigma_a rho_pi (sigma_a - kappa), rho_g D)\
D & = beta sigma_a + sigma_a + kappa $

y

$ K = frac(alpha (- sigma_a + C^(‾) sigma_a - C^(‾) kappa + tau sigma_a - B^(‾) sigma_a^2 + B^(‾) sigma_a kappa + B^(‾) beta sigma_a^2 - B^(‾) beta sigma_a kappa), B^(‾) beta rho_g D) $

=== Juego extensivo
<juego-extensivo>
#par()[#text(size:0.5em)[#h(0.0em)]]
#v(-18pt)
La dinámica secuencial entre las autoridades se modela mediante un juego en forma extensiva, representado por un árbol de decisiones con información perfecta. En este escenario, el jugador que realiza el primer movimiento asume el papel de líder de Stackelberg, mientras que el segundo jugador actúa como seguidor. La solución se obtiene mediante el concepto de equilibrio perfecto en subjuegos, donde el análisis procede desde los nodos terminales hacia el inicio del árbol de decisión.

==== Derivación de las curvas de reacción bajo un regimen de dominancia monetaria.
<derivación-de-las-curvas-de-reacción-bajo-un-regimen-de-dominancia-monetaria>
En un regimen de dominancia monetaria, el Banco Central es el lider de Stackelberg. Este resuelve su problema de optimización tomando en consideración la mejor respuesta del Ministerio de Hacienda. La ventaja de elegir primero permite al Banco Central tomar en cuenta la función de reacción fiscal en su proceso de toma de decisiones. Por lo tanto, en esta derivación de la política óptima, el Banco Central toma el resultado del equilibrio de Nash no cooperativo del ministerio de Hacienda, es decir, la regla de política fiscal óptima $tilde(g)_t^(N C N)$ @eq-regla-optima-mh-ncn y la sustituye por $tilde(g)$ en las restricciones del lagrangiano. Esto se sustenta porque la regla de política fiscal óptima es la mejor respuesta por parte de Hacienda en el subjuego.

En la segunda etapa del juego, el Banco Central tiene que resolver el siguiente problema de optimización tomando en cuenta el resultado perfecto en subjuegos del Ministerio de Hacienda: #math.equation(block: true, numbering: "(1)", [ $ min_(r_t) E_0 (1 / 2 gamma_pi V a r (pi_t) + 1 / 2 gamma_y V a r (tilde(y)_t) + 1 / 2 gamma_r V a r (r_t - r^(\*))) $ ])<eq-nash-bc-opt>

Que al sustituir los valores $pi_t$ por @eq-cp-neokeynesiana, $tilde(y)_t$ por @eq-is y $tilde(g)$ por $tilde(g)_t^(N C N)$, obtenemos un problema de optimización no restringida con respecto a $(r_t - r^(\*))$ se expresa como:

$ O = E_0 {sum_(t = 0)^oo beta^t vec(1 / 2 gamma_pi (beta pi_(H , t + 1) + kappa tilde(y)_t + sigma_alpha tilde(g)_t^(B R) + epsilon_t^pi)^2, + 1 / 2 gamma_y (tilde(y)_(t + 1) - 1 / sigma_alpha (r_t - pi_(H , t + 1) - r^N) - tilde(g)_(t + 1) + tilde(g)_t^(B R))^2, + 1 / 2 gamma_r (r_t - r^(\*))^2)} $

El resultado de susodicho proceso de optimización es la siguiente regla óptima de tasas de interés:

#math.equation(block: true, numbering: "(1)", [ $ r_t^(M L) = K & - Upsilon_(g , + 1) E_t { tilde(g)_(t + 1) } + Upsilon_(g , 1) tilde(g)_(t - 1) + Upsilon_(y , + 1) E_t { tilde(y)_(t + 1) }\
 & - Upsilon_(y , 0) tilde(y)_t + Upsilon_(y , 1) tilde(y)_(t - 1) + Upsilon_(pi , + 1) E_t { pi_(t + 1) } - Upsilon_(pi , 0) pi_t + r^(\*) + Upsilon_(r^N , 0) upsilon_t^N $ ])<eq-regla-optima-bc-stack>

Donde, para simplificación, usamos:

$ Upsilon_(g , + 1) & = frac(gamma_y sigma_a (kappa + sigma_a), V)\
Upsilon_(g , 1) & = frac(gamma_y sigma_a^2, V)\
Upsilon_(y , + 1) & = frac(gamma_y sigma_a (rho_g kappa + rho_g beta sigma_a + rho_g sigma_a + beta sigma_a rho_g), rho_g V)\
Upsilon_(y , 0) & = frac(gamma_y rho_g sigma_a^2 (beta + 2), rho_g V)\
Upsilon_(y , 1) & = frac(gamma_y rho_g sigma_a^2, rho_g V)\
Upsilon_(pi , + 1) & = frac(gamma_y (- beta sigma_a^2 rho_pi - rho_g beta sigma_a - rho_g sigma_a + beta sigma_a^3 rho_pi - rho_g kappa), rho_g V)\
Upsilon_(pi , 0) & = frac(gamma_y rho_a sigma_a^2 (sigma_a - kappa), rho_g V)\
z & = frac(gamma_y sigma_a, gamma_y + gamma_r sigma_a^2)\
Upsilon_(r^N , 0) & = frac(gamma_y, gamma_r sigma_a^2 + gamma_y) $

$ K = frac(gamma_y sigma_a alpha (sigma_a tau^(‾) - sigma_a - C^(‾) kappa + sigma_a^2 B^(‾) beta - sigma_a B^(‾) beta kappa - sigma_a^2 B^(‾) + sigma_a C^(‾) + sigma_a B^(‾) kappa), rho_g B^(‾) beta V) $

$ V = gamma_y beta sigma_a + gamma_y sigma_a + gamma_y kappa + gamma_y beta sigma_a^3 + gamma_r sigma_a^3 + gamma_y sigma_a^2 kappa $

@eq-regla-optima-bc-stack representa la regla de política monetaria óptima en el juego con liderazgo monetario. Esta formulación se distingue de la regla de tasa de interés obtenida en el juego no cooperativo de Nash, ya que incorpora respuestas a variables adicionales referentes a la política fiscal. Esto hace que la regla este determinada por múltiples factores: la inflación esperada y actual, la brecha del producto en sus dimensiones esperada, presente y pasada, el gasto gubernamental tanto pasado como esperado, y las tasas de interés de equilibrio y natural.

==== Derivación de la curva de reacción bajo un regimen de dominancia fiscal.
<derivación-de-la-curva-de-reacción-bajo-un-regimen-de-dominancia-fiscal>
En un regimen de dominancia fiscal, el Ministerio de Hacienda juega como el líder de Stackelberg y el Banco Central como seguidor. Por lo tanto, el Ministerio de Hacienda resuelve su problema de optimización tomando en consideración la mejor respuesta del Banco Central. Es decir, la regla de política monetaria óptima $r_t^(N C N)$ para el juego de Nash no cooperativo. Este resultado, planteado en el problema @eq-regla-optima-bc-ncn, es el equilibrio perfecto en subjuegos para el Banco Central como seguidor.

En la segunda etapa del juego, el Ministerio de Hacienda intenta resolver problema de optimización, tomando en cuenta las respuestas que pudiera tener Banco Central a sus estrategias.Por lo tanto, optimizando de manera tal que incorpore en su proceso de desicion las reacciones del mismo. Resultando en el siguiente problema:

$ O = E_0 {sum_(t = 0)^oo beta^t mat(delim: "[", 1 / 2 rho_pi (beta pi_(H , t + 1) + kappa tilde(y)_t + sigma_a tilde(g)_t + epsilon_t^pi)^2; + 1 / 2 rho_y (tilde(y)_(t + 1) - 1 / sigma_a (r_t^(B R) - pi_(H , t + 1) - r_t^N) - tilde(g)_(t + 1) + tilde(g)_t)^2; + 1 / 2 rho_g tilde(g)_t^2)} $

Al resolver el problema de optmiización no restringida, y despejar con respecto a $tilde(g)_t^(N C N)$ obtenemos la siguiente regla de política fiscal óptima:

#math.equation(block: true, numbering: "(1)", [ $ Xi_(pi , 0) pi_(H , t) & - Xi_(y , + 1) E_t { tilde(y)_(t + 1) } + Xi_(y , 0) tilde(y)_t - Xi_(y , 1) tilde(y)_(t - 1) + w epsilon_t^pi\
 & + Xi_(pi , 0) pi_(H , t) - Xi_(y , + 1) E_t { tilde(y)_(t + 1) } + Xi_(y , 0) tilde(y)_t - Xi_(y , 1) tilde(y)_(t - 1) + w epsilon_t^pi $ ])<eq-regla-optima-mh-stack>

Donde, para simplificación, usamos:

$ Xi_(g , + 1) & = rho_y / J , & Xi_y & = frac(rho_y kappa, beta J) , & Xi_(y') & = frac(rho_g, sigma_a J) , & Xi_(r , 1) & = frac(rho_y (sigma_a kappa + beta + 1), sigma_a beta J) , & Xi_(r , 2) & = frac(rho_y, sigma_a beta J)\
Xi_(pi , + 1) & = frac((- rho_g sigma_a^2 beta + rho_y), sigma_a J) , & Xi_(pi , 0) & = frac(rho_y gamma_y kappa, sigma_a^2 gamma_r J) , & Xi_(y , + 1) & = rho_y / J , & Xi_(y , 0) & = frac((rho_y gamma_y + rho_g sigma_a^2 gamma_r kappa), sigma_a^2 gamma_r J) , & Xi_(y , 1) & = frac(rho_y gamma_y, sigma_a^2 gamma_r J) $

Donde, $w = frac(rho_g sigma_a, J)$ y $J = rho_g + rho_y + rho_y sigma_a^2$ se utilizaron para simplificar.

== Calibración paramétrica para la simulación dinámica
<calibración-paramétrica-para-la-simulación-dinámica>
= Resultados
<resultados>
== Análisis de perdidas sociales: Determinación del regimen de interacción óptimo
<análisis-de-perdidas-sociales-determinación-del-regimen-de-interacción-óptimo>
== Análisis de los choques estructurales: Función de impulso-reacción
<análisis-de-los-choques-estructurales-función-de-impulso-reacción>
== Análisis de sensibilidad: Evaluación de la estabilidad paramétrica por filtro de Monte Carlo
<análisis-de-sensibilidad-evaluación-de-la-estabilidad-paramétrica-por-filtro-de-monte-carlo>
= Conclusiones y Recomendaciones
<conclusiones-y-recomendaciones>
#pagebreak()
= Referencias
<referencias>
References marked with an asterisk indicate studies included in the meta-analysis.

#set par(first-line-indent: 0in, hanging-indent: 0.5in)
#block[
#block[
Aarle, B. van, Bovenberg, A. L., & Raith, M. (1995). Monetary and fiscal policy interaction and government debt stabilization. #emph[Discussion Paper];. #link("https://ideas.repec.org//p/tiu/tiucen/3e0859f2-375c-4cf5-bf90-4555884390b7.html")

] <ref-van_aarle_monetary_1995>
#block[
Adjemian, S., Bastani, H., Juillard, M., Karamé, F., Maih, J., Mihoubi, F., Perendia, G., Pfeifer, J., Ratto, M., & Villemot, S. (2011). #emph[Dynare: Reference Manual, Version 4];. CEPREMAP.

] <ref-adjemian_dynare_2011>
#block[
Aliaga Miranda, A. (2020). Monetary policy rules for an open economy with financial frictions: A Bayesian approach. #emph[Dynare Working Papers];. #link("https://ideas.repec.org//p/cpm/dynare/062.html")

] <ref-aliaga_miranda_monetary_2020>
#block[
Barro, R. J., & Gordon, D. B. (1983). #emph[Rules, Discretion and Reputation in a Model of Monetary Policy] (1079). National Bureau of Economic Research. #link("https://doi.org/10.3386/w1079")

] <ref-barro_rules_1983>
#block[
Bartolomeo, G. D., & Gioacchino, D. D. (2005). #emph[Fiscal-Monetary Policy Coordination And Debt Management: A Two Stage Dynamic Analysis] (Macroeconomics 0504024). University Library of Munich, Germany. #link("https://ideas.repec.org/p/wpa/wuwpma/0504024.html")

] <ref-bartolomeo_fiscal-monetary_2005>
#block[
Calvo, G. A. (1983). Staggered prices in a utility-maximizing framework. #emph[Journal of Monetary Economics];, #emph[12];(3), 383-398. #link("https://doi.org/10.1016/0304-3932(83)90060-0")

] <ref-calvo_staggered_1983>
#block[
Clarida, R., Gali, J., & Gertler, M. (1999). The Science of Monetary Policy: A New Keynesian Perspective. #emph[Journal of Economic Literature];, #emph[37];(4), 1661-1707. #link("https://doi.org/10.1257/jel.37.4.1661")

] <ref-clarida_science_1999>
#block[
Cruz-Rodríguez, A. (2006, junio 20). #emph[El déficit cuasifiscal del Banco Central de la República Dominicana] \[{MPRA} Paper\]. #link("https://mpra.ub.uni-muenchen.de/109191/")

] <ref-cruz-rodriguez_deficit_2006>
#block[
Fragetta, M., & Kirsanova, T. (2010). Strategic monetary and fiscal policy interactions: An empirical investigation. #emph[European Economic Review];, #emph[54];(7), 855-879. #link("https://ideas.repec.org//a/eee/eecrev/v54y2010i7p855-879.html")

] <ref-fragetta_strategic_2010>
#block[
Friedman, M. (1971). Government Revenue from Inflation. #emph[Journal of Political Economy];, #emph[79];(4), 846-856. #link("https://doi.org/10.1086/259791")

] <ref-friedman_government_1971>
#block[
Gali, J., & Gertler, M. (2000). #emph[Inflation Dynamics: A Structural Econometric Analysis] (7551). National Bureau of Economic Research. #link("https://doi.org/10.3386/w7551")

] <ref-gali_inflation_2000>
#block[
Galí, J. (2015). Monetary Policy, Inflation, and the Business Cycle: An Introduction to the New Keynesian Framework and Its Applications Second edition. #emph[Economics Books];. #link("https://ideas.repec.org//b/pup/pbooks/10495.html")

] <ref-gali_monetary_2015>
#block[
Galí, J., & Monacelli, T. (2005). Monetary Policy and Exchange Rate Volatility in a Small Open Economy. #emph[The Review of Economic Studies];, #emph[72];(3), 707-734. #link("https://ideas.repec.org/a/oup/restud/v72y2005i3p707-734.html")

] <ref-gali_monetary_2005>
#block[
Giannoni, M., & Woodford, M. (2003). #emph[Optimal Interest-Rate Rules: I. General Theory] ({NBER} Working Paper 9419). National Bureau of Economic Research, Inc. #link("https://econpapers.repec.org/paper/nbrnberwo/9419.htm")

] <ref-giannoni_optimal_2003>
#block[
Gobierno de la República Dominicana. (s.~f.). #emph[Ley No. 183-02 Monetaria y Financiera];. Recuperado 23 de noviembre de 2024, de #link("https://www.sb.gob.do/regulacion/compendio-de-leyes-y-reglamentos/ley-no-183-02-monetaria-y-financiera/")

] <ref-gobierno_de_la_republica_dominicana_ley_nodate>
#block[
HALLETT, A. H., LIBICH, J., & STEHLÍK, P. (2014). Monetary and Fiscal Policy Interaction with Various Degrees of Commitment. #emph[Czech Journal of Economics and Finance (Finance a uver)];, #emph[64];(1), 2-29. #link("https://ideas.repec.org/a/fau/fauart/v64y2014i1p2-29.html")

] <ref-hallett_monetary_2014>
#block[
Henry, B., Nixon, J., & Hall, S. (2003). Central Bank Independence and Co‐ordinating Monetary and Fiscal Policy. #emph[Economic Outlook];, #emph[23];, 7-13. #link("https://doi.org/10.1111/1468-0319.00162")

] <ref-henry_central_2003>
#block[
Hidalgo, M. (2024, septiembre 9). #emph[Economista propone transferir deuda del Banco Central al Ministerio de Hacienda. El Nuevo Diario (República Dominicana)];. #link("https://elnuevodiario.com.do/economista-propone-transferir-deuda-del-banco-central-al-ministerio-de-hacienda/")

] <ref-hidalgo_economista_2024>
#block[
Hinterlang, N., & Hollmayr, J. (2022). Classification of monetary and fiscal dominance regimes using machine learning techniques. #emph[Journal of Macroeconomics];, #emph[74];, 103469. https:\/\/doi.org/#link("https://doi.org/10.1016/j.jmacro.2022.103469")

] <ref-hinterlang_classification_2022>
#block[
Kleineman, J. (Ed.). (2021). #emph[Central Bank Independence: The Economic Foundations, the Constitutional Implications and Democratic Accountability];. Brill Nijhoff. #link("https://brill.com/edcollbook/title/10804")

] <ref-kleineman_central_2021>
#block[
Kydland, F. E., & Prescott, E. C. (1977). Rules Rather than Discretion: The Inconsistency of Optimal Plans. #emph[Journal of Political Economy];, #emph[85];(3), 473-491. #link("https://www.jstor.org/stable/1830193")

] <ref-kydland_rules_1977>
#block[
Malovana, S. (2015). Foreign Exchange Interventions at the Zero Lower Bound in the Czech Economy: A DSGE Approach. #emph[Working Papers IES];. #link("https://ideas.repec.org//p/fau/wpaper/wp2015_13.html")

] <ref-malovana_foreign_2015>
#block[
Masked Citation. (n.d.). #emph[Masked Title];.

] <ref-maskedreference>
#block[
Nordhaus, W. (1994). Policy games: Coordination and Independece in Monetary and Fiscal Policies. #emph[Brookings Papers on Economic Activity];, #emph[25];(2), 139-216. #link("https://econpapers.repec.org/article/binbpeajo/v_3a25_3ay_3a1994_3ai_3a1994-2_3ap_3a139-216.htm")

] <ref-nordhaus_policy_1994>
#block[
OECD. (2012). #emph[El mercado de capitales en República Dominicana: Aprovechando su potencial para el desarrollo];. Organisation for Economic Co-operation; Development. #link("https://www.oecd-ilibrary.org/fr/development/el-mercado-de-capitales-en-republica-dominicana_9789264177680-es")

] <ref-oecd_mercado_2012>
#block[
Pérez Pérez, M. A. (2021). #emph[Nueva literatura económica dominicana: premios del Concurso de Economía «Biblioteca Juan Pablo Duarte» 2020] (J. Alcántara Almánzar, E. F. Soto, F. A. Pérez Quiñones, I. Miolán, & H. Batista, Eds.). Banco Central de la República Dominicana (BCRD).

] <ref-perez_perez_nueva_2021>
#block[
Petit, M. L. (1989). Fiscal and Monetary Policy Co-Ordination: A Differential Game Approach. #emph[Journal of Applied Econometrics];, #emph[4];(2), 161-179. #link("https://www.jstor.org/stable/2096467")

] <ref-petit_fiscal_1989>
#block[
Ramírez, F. A., & Torres, F. (2014). Modelo de Equilibrio General Dinámico y Estocástico con Rigideces Nominales para el Análisis de Política y Proyecciones en la República Dominicana. #emph[Foro de Investigadores de Bancos Centrales del Consejo Monetario Centroamericano];. #link("https://www.secmca.org/recard/index.php/foro/article/view/69")

] <ref-ramirez_modelo_2014>
#block[
Sandström, C. (2022). #emph[Inflation and Quantitative Tightening - A theoretical assessment of contractionary monetary policy and real economic activity];. #link("http://lup.lub.lu.se/student-papers/record/9096134")

] <ref-sandstrom_inflation_2022>
#block[
Sargent, T. J., & Wallace, N. (1981). Some unpleasant monetarist arithmetic. #emph[Quarterly Review];, #emph[5];. #link("https://ideas.repec.org//a/fip/fedmqr/y1981ifallnv.5no.3.html")

] <ref-sargent_unpleasant_1981>
#block[
Saulo, H., Rêgo, L. C., & Divino, J. A. (2013). Fiscal and monetary policy interactions: a game theory approach. #emph[Annals of Operations Research];, #emph[206];(1), 341-366. #link("https://doi.org/10.1007/s10479-013-1379-3")

] <ref-saulo_fiscal_2013>
#block[
Svensson, L. E. O. (1997). Inflation forecast targeting: Implementing and monitoring inflation targets. #emph[European Economic Review];, #emph[41];(6), 1111-1146. #link("https://ideas.repec.org//a/eee/eecrev/v41y1997i6p1111-1146.html")

] <ref-svensson_inflation_1997>
#block[
Taylor, J. B. (1993). Discretion versus policy rules in practice. #emph[Carnegie-Rochester Conference Series on Public Policy];, #emph[39];(1), 195-214. #link("https://ideas.repec.org//a/eee/crcspp/v39y1993ip195-214.html")

] <ref-taylor_discretion_1993>
#block[
Tetik, M., & Ceylan, R. (2021). Evaluation of Stackelberg Leader-Follower Interaction Between Policymakers in Small-Scale Open Economies\*. #emph[Ekonomika];, #emph[100];(2), 101-132. #link("https://www.redalyc.org/journal/6922/692272891005/html/")

] <ref-tetik_evaluation_2021>
] <refs>
#set par(first-line-indent: 0.5in, hanging-indent: 0in)
#pagebreak()
= Apéndice
<apéndice>


 
  
#set bibliography(style: "_extensions/wjschne/apaquarto/apa.csl") 


