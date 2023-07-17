# Znn

`Znn` is an Elixir implementation of a nearest-neighbors text classifier that uses 
the Normalized Compression Distance. This approach is detailed in

> [Jiang et al., _“Low-Resource” Text Classification: A Parameter-Free Classification Method with Compressors_](https://aclanthology.org/2023.findings-acl.426/)

## Basic usage

Provide a training sample of labeled text data in the form

```elixir
> training_set = [
    %{label: "clickbait", text: "21 Outrageously Creative Ways To Make Meatballs"},
    %{label: "non_clickbait", text: "H5N1 Avian Flu virus has mutated, study says"},
    ...
  ]
```

To predict the label of a new piece of text, call the `predict` function:

```elixir
> text = "10 Amazing Ways To Grow Bigger Pumpkins"
> Znn.predict(text, training_set)
"clickbait"
```

