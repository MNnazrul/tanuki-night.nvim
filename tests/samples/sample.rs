#[derive(Clone, Debug)]
pub struct Inventory {
    slots: Vec<Option<Item>>,
}
impl Inventory {
    pub fn new(size: usize) -> Self {
        let mut count = 0;
        let name = String::from("x");
        match self.get() { Some(x) => x, None => 1 }
    }
}
